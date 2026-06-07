import argparse
import csv
import re
import time
from pathlib import Path
from urllib.parse import urljoin, urlparse

from playwright.sync_api import TimeoutError as PlaywrightTimeoutError
from playwright.sync_api import sync_playwright


DEFAULT_URL = (
    "https://ca.pinterest.com/pin/10133167906650545/visual-search/"
    "?cropSource=5&entrypoint=closeup_cta"
)
DEFAULT_LOGIN_URL = "https://www.pinterest.com/login/"
DEFAULT_AUTH_STATE_PATH = Path(".auth") / "pinterest_auth.json"
DEFAULT_IMAGES_DIR = Path("images")
PIN_PATH_RE = re.compile(r"/pin/(\d+)/?")


def parse_args():
    parser = argparse.ArgumentParser(
        description="Scrape Pinterest visual-search pin links from anchor hrefs."
    )
    parser.add_argument(
        "url",
        nargs="?",
        default=DEFAULT_URL,
        help="Pinterest visual-search URL to scrape.",
    )
    parser.add_argument(
        "-l",
        "--limit",
        type=int,
        default=100,
        help="Number of unique pins to scrape.",
    )
    parser.add_argument(
        "-o",
        "--output",
        default="data.csv",
        help="CSV output file.",
    )
    parser.add_argument(
        "--download-images",
        action="store_true",
        help="Download the scraped pin tile images.",
    )
    parser.add_argument(
        "--images-dir",
        default=str(DEFAULT_IMAGES_DIR),
        help="Directory where downloaded pin images are saved.",
    )
    parser.add_argument(
        "--headful",
        action="store_true",
        help="Show the browser window while scraping.",
    )
    parser.add_argument(
        "--login",
        action="store_true",
        help="Open a browser for manual Pinterest login and save auth state.",
    )
    parser.add_argument(
        "--login-only",
        action="store_true",
        help="Save auth state from manual login, then exit without scraping.",
    )
    parser.add_argument(
        "--login-url",
        default=DEFAULT_LOGIN_URL,
        help="Pinterest URL to open for manual login.",
    )
    parser.add_argument(
        "--auth-state",
        default=str(DEFAULT_AUTH_STATE_PATH),
        help="Path to the Playwright storage state JSON file.",
    )
    parser.add_argument(
        "--max-scrolls",
        type=int,
        default=80,
        help="Maximum scroll attempts before giving up.",
    )
    parser.add_argument(
        "--scroll-delay",
        type=float,
        default=1.2,
        help="Seconds to wait after each scroll.",
    )
    return parser.parse_args()


def browser_context_options(auth_state_path=None):
    options = {
        "viewport": {"width": 1366, "height": 900},
        "user_agent": (
            "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
            "(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        ),
    }

    if auth_state_path and auth_state_path.exists():
        options["storage_state"] = str(auth_state_path)

    return options


def save_auth_state(playwright, auth_state_path, login_url):
    auth_state_path.parent.mkdir(parents=True, exist_ok=True)

    browser = playwright.chromium.launch(headless=False)
    try:
        context = browser.new_context(**browser_context_options())
        try:
            page = context.new_page()
            page.goto(login_url, wait_until="domcontentloaded", timeout=60_000)
            print("Log in to Pinterest in the browser window.")
            print(
                "After Pinterest shows your logged-in account, return here "
                f"and press Enter to save {auth_state_path}."
            )
            input()
            context.storage_state(path=str(auth_state_path))
        finally:
            context.close()
    finally:
        browser.close()

    print(f"Saved Pinterest auth state to {auth_state_path}")


def pin_url_from_href(href, page_url):
    if not href:
        return None, None

    absolute_url = urljoin(page_url, href)
    parsed = urlparse(absolute_url)
    match = PIN_PATH_RE.search(parsed.path)
    if not match:
        return None, None

    pin_id = match.group(1)
    normalized_url = f"{parsed.scheme}://{parsed.netloc}/pin/{pin_id}/"
    return pin_id, normalized_url


def best_image_url(src, srcset):
    if not srcset:
        return src

    candidates = []
    for item in srcset.split(","):
        parts = item.strip().rsplit(" ", 1)
        if not parts or not parts[0]:
            continue

        image_url = parts[0]
        descriptor = parts[1] if len(parts) > 1 else ""
        score = 0
        if descriptor.endswith("x"):
            try:
                score = float(descriptor[:-1])
            except ValueError:
                score = 0
        elif descriptor.endswith("w"):
            try:
                score = float(descriptor[:-1]) / 100
            except ValueError:
                score = 0

        if "/originals/" in image_url:
            score += 1000

        candidates.append((score, image_url))

    if not candidates:
        return src

    return max(candidates, key=lambda candidate: candidate[0])[1]


def extension_from_url(image_url, content_type=None):
    parsed_path = urlparse(image_url).path
    extension = Path(parsed_path).suffix.lower()
    if extension in {".jpg", ".jpeg", ".png", ".gif", ".webp"}:
        return extension

    if content_type:
        content_type = content_type.split(";", 1)[0].strip().lower()
        return {
            "image/jpeg": ".jpg",
            "image/png": ".png",
            "image/gif": ".gif",
            "image/webp": ".webp",
        }.get(content_type, ".jpg")

    return ".jpg"


def visible_pin_anchors(page):
    return page.evaluate(
        """
        () => Array.from(document.querySelectorAll('a[href*="/pin/"]')).map((anchor) => ({
            href: anchor.getAttribute("href"),
            aria_label: anchor.getAttribute("aria-label") || "",
            text: (anchor.innerText || anchor.textContent || "").trim(),
            img_src: anchor.querySelector("img")?.src || "",
            img_srcset: anchor.querySelector("img")?.srcset || "",
            img_alt: anchor.querySelector("img")?.alt || "",
        }))
        """
    )


def scrape_pins(page, source_url, limit, max_scrolls, scroll_delay):
    rows_by_pin_id = {}
    stale_scrolls = 0
    last_count = 0

    for scroll_number in range(max_scrolls + 1):
        for anchor in visible_pin_anchors(page):
            pin_id, pin_url = pin_url_from_href(anchor["href"], page.url)
            if not pin_id:
                continue

            image_url = best_image_url(anchor["img_src"], anchor["img_srcset"])
            existing_row = rows_by_pin_id.get(pin_id)
            if existing_row:
                if image_url and not existing_row["image_url"]:
                    existing_row["image_url"] = image_url
                    existing_row["image_alt"] = anchor["img_alt"]
                if anchor["aria_label"] and not existing_row["aria_label"]:
                    existing_row["aria_label"] = anchor["aria_label"]
                if anchor["text"] and not existing_row["text"]:
                    existing_row["text"] = anchor["text"]
                continue

            rows_by_pin_id[pin_id] = {
                "pin_id": pin_id,
                "pin_url": pin_url,
                "href": anchor["href"],
                "aria_label": anchor["aria_label"],
                "text": anchor["text"],
                "image_alt": anchor["img_alt"],
                "image_url": image_url,
                "image_path": "",
                "source_url": source_url,
            }

            if len(rows_by_pin_id) >= limit:
                return list(rows_by_pin_id.values())[:limit]

        current_count = len(rows_by_pin_id)
        if current_count == last_count:
            stale_scrolls += 1
        else:
            stale_scrolls = 0
            print(f"Collected {current_count}/{limit} pins")

        if stale_scrolls >= 8:
            break

        last_count = current_count
        page.mouse.wheel(0, 1800)
        page.wait_for_timeout(int(scroll_delay * 1000))

        if scroll_number and scroll_number % 10 == 0:
            page.evaluate("window.scrollBy(0, window.innerHeight * 2)")
            time.sleep(0.2)

    return list(rows_by_pin_id.values())[:limit]


def write_csv(rows, output_path):
    fieldnames = [
        "pin_id",
        "pin_url",
        "href",
        "aria_label",
        "text",
        "image_alt",
        "image_url",
        "image_path",
        "source_url",
    ]
    with output_path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def download_pin_images(context, rows, images_dir):
    images_dir.mkdir(parents=True, exist_ok=True)
    downloaded = 0

    for row in rows:
        image_url = row.get("image_url")
        if not image_url:
            continue

        response = context.request.get(image_url, timeout=60_000)
        if not response.ok:
            print(f"Skipped {row['pin_id']}: image request failed with {response.status}")
            continue

        extension = extension_from_url(
            image_url,
            response.headers.get("content-type"),
        )
        image_path = images_dir / f"{row['pin_id']}{extension}"
        image_path.write_bytes(response.body())
        row["image_path"] = str(image_path)
        downloaded += 1

        if downloaded % 10 == 0:
            print(f"Downloaded {downloaded} images")

    return downloaded


def main():
    args = parse_args()
    output_path = Path(args.output)
    auth_state_path = Path(args.auth_state)
    images_dir = Path(args.images_dir)

    with sync_playwright() as p:
        if args.login or args.login_only:
            save_auth_state(p, auth_state_path, args.login_url)
            if args.login_only:
                return

        if not auth_state_path.exists():
            print(
                f"Auth state not found at {auth_state_path}; scraping without "
                "a saved Pinterest login. Run with --login to create it."
            )

        browser = p.chromium.launch(headless=not args.headful)
        try:
            context = browser.new_context(**browser_context_options(auth_state_path))
            try:
                page = context.new_page()

                try:
                    page.goto(args.url, wait_until="domcontentloaded", timeout=60_000)
                    page.wait_for_selector('a[href*="/pin/"]', timeout=30_000)
                except PlaywrightTimeoutError:
                    print(
                        "Timed out waiting for initial Pinterest pin anchors; "
                        "scrolling anyway."
                    )

                rows = scrape_pins(
                    page=page,
                    source_url=args.url,
                    limit=args.limit,
                    max_scrolls=args.max_scrolls,
                    scroll_delay=args.scroll_delay,
                )

                if args.download_images:
                    downloaded = download_pin_images(context, rows, images_dir)
                    print(f"Downloaded {downloaded} images to {images_dir}")
            finally:
                context.close()
        finally:
            browser.close()

    write_csv(rows, output_path)
    print(f"Wrote {len(rows)} pins to {output_path}")


if __name__ == "__main__":
    main()
