# Pinterest Playwright Commands

Create or refresh the saved Pinterest login JSON:

```bash
.venv/bin/python main.py --login-only
```

After the browser opens, log in to Pinterest manually. When login is complete, return to the terminal and press Enter. This writes:

```text
.auth/pinterest_auth.json
```

Download only the top 100 pin links to CSV:

```bash
.venv/bin/python main.py --limit 100 --output data.csv
```

Download the top 100 pin links and images:

```bash
.venv/bin/python main.py --limit 100 --download-images --images-dir images --output data.csv
```

Use a different Pinterest visual-search URL:

```bash
.venv/bin/python main.py "PASTE_PINTEREST_VISUAL_SEARCH_URL_HERE" --limit 100 --output data.csv
```

Use a different Pinterest visual-search URL:

```bash
.venv/bin/python main.py "PASTE_PINTEREST_VISUAL_SEARCH_URL_HERE"  --limit 40 --download-images --images-dir images --output data.csv
```

Use a different Pinterest search URL:

```bash
.venv/bin/python main.py "https://ca.pinterest.com/search/pins/?q=grade%201%20english%20worksheets%20for%20kids%20cvc&rs=ac&len=30&source_id=ac_UFnsME8q&eq=grade%201%20english%20worksheets%20for&etslf=11959"  --limit 1 --download-images --images-dir images --output data.csv
.venv/bin/python main.py "PASTE_PINTEREST_SEARCH_URL_HERE"  --limit 50 --download-images --images-dir images --output data.csv
```
