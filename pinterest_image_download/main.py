import argparse
from pathlib import Path

from pinterest_dl import PinterestDL
from pinterest_dl.exceptions import PinterestAPIError


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Download Pinterest media from a real pin/board URL or search query."
    )
    subparsers = parser.add_subparsers(dest="command")

    scrape_parser = subparsers.add_parser(
        "scrape",
        help="download media from a Pinterest pin, board, or board section URL",
    )
    scrape_parser.add_argument("url", help="Pinterest pin/board URL")

    search_parser = subparsers.add_parser(
        "search",
        help="download media from Pinterest search results",
    )
    search_parser.add_argument("query", help="search text, for example: landscape art")

    for subparser in (scrape_parser, search_parser):
        subparser.add_argument(
            "-n",
            "--num",
            type=int,
            default=30,
            help="maximum number of media items to download",
        )
        subparser.add_argument(
            "-o",
            "--output-dir",
            type=Path,
            default=Path("images"),
            help="directory where downloaded media will be saved",
        )
        subparser.add_argument(
            "--verbose",
            action="store_true",
            help="show detailed pinterest-dl logging",
        )

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return 0

    scraper = PinterestDL.with_api(verbose=args.verbose)

    try:
        if args.command == "scrape":
            images = scraper.scrape_and_download(
                url=args.url,
                output_dir=args.output_dir,
                num=args.num,
            )
        else:
            images = scraper.search_and_download(
                query=args.query,
                output_dir=args.output_dir,
                num=args.num,
            )
    except PinterestAPIError as exc:
        print(f"Pinterest request failed: {exc}")
        print("Use a real, public Pinterest URL. The old 1234567 example URL is fake.")
        return 1

    count = len(images or [])
    print(f"Downloaded {count} item(s) to {args.output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
