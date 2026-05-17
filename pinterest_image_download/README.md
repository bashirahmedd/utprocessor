# Pinterest Image Download

Small command-line tool for downloading Pinterest media from a public pin, board, board section URL, or search query.

$python main.py scrape -n 50 https://ca.pinterest.com/pin/11329436558807788/
$python main.py scrape -n 50 https://ca.pinterest.com/pin/880242690195915263/visual-search/?cropSource=5&entrypoint=closeup_cta

## Requirements

- Python 3.10 or newer
- Dependencies listed in `requirements.txt`

## Setup

Create and activate a virtual environment:

```bash
python -m venv .venv
source .venv/bin/activate
```

Install dependencies:

```bash
python -m pip install -r requirements.txt
```

If browser automation is needed by `pinterest-dl`, install Playwright's Chromium browser:

```bash
python -m playwright install chromium
```

## Usage

Show help:

```bash
python main.py --help
```

Download media from a Pinterest URL:

```bash
python main.py scrape "https://www.pinterest.com/pin/example/" -n 30 -o images
```

Download media from Pinterest search results:

```bash
python main.py search "landscape art" -n 30 -o images
```

## Options

- `-n`, `--num`: maximum number of media items to download. Default: `30`
- `-o`, `--output-dir`: folder where downloaded files are saved. Default: `images`
- `--verbose`: show detailed `pinterest-dl` logging

## Notes

- Use real, public Pinterest URLs for scraping.
- Downloaded files are saved to the output directory you choose.
- This project uses the third-party `pinterest-dl` package and is not affiliated with Pinterest.
