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
