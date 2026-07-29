# Lock Hunter

A Windows desktop app for lock collectors. It finds locks for sale across dozens
of marketplaces worldwide, built around the official
[LPU (Lockpickers United) belt catalog](https://lpubelts.com).

> ⚠️ **Please read the [Disclaimer](DISCLAIMER.md).** Lock Hunter is a personal,
> hobbyist tool, not affiliated with LPU, lpubelts.com, eBay, or any marketplace.
> You are responsible for using it in line with each site's terms of service.

## Features

- **Live search** for any LPU-ranked lock (900+ catalog) or custom terms across
  ~46 marketplaces in 30+ countries, all queried at once so a full hunt takes
  seconds. eBay runs alongside the sweep.
- **Full belt catalog** with photos, Black 1–5 sub-tiers, and a **Rarity** column
  (stars) based on how many LPU members own each lock — sortable rarest-first.
- **Your collection**: Owned and Wishlist, imported from your lpubelts.com
  profile.
- **Hunt Wishlist**: search every lock on your wishlist in one run.
- **Compare tab**: paste any collector's profile link for a two-way trade check.
- **New-on-the-Bazaar alerts** for wishlist locks, plus a daily update check.
- **Excel export** with clickable listing links, rarity, and seller columns.
- **Optional AI web search** (off by default): can also ask an Anthropic (Claude)
  model to web-search for a lock. This is **not free** — it uses **your own**
  Anthropic API key and costs a small amount of API credit per run (usually a few
  US cents). The normal search is completely free.

## Install (the easy way — no Python)

**New to this? See the step-by-step [How to Install](HOW-TO-INSTALL.md) guide** —
it walks through the whole thing with pictures of what each warning looks like.

Grab `LockHunter.exe` from the [Releases](../../releases) page and run it. The
single file is the whole program; there's nothing to install.

The first launch may show a Windows SmartScreen "Windows protected your PC"
warning — this is normal for any app that isn't code-signed. Click **More info →
Run anyway**. (Prefer not to trust a downloaded `.exe`? Run from source instead —
see below.)

## Run from source

```bash
git clone https://github.com/ckaralis85-spec/lock-hunter.git
cd lock-hunter
python -m pip install -r requirements.txt
python lock_hunter.py
```

Python 3.10+ is recommended. On most Linux distros you also need the Tk package
(`sudo apt install python3-tk`); on Windows and macOS it ships with Python.

## Build the .exe yourself

On a Windows PC with Python installed, run **`DEVELOPER ONLY - Build EXE.bat`**.
It freezes a standalone `dist\LockHunter.exe` with PyInstaller. (CI can do this
automatically — see `.github/workflows/build.yml`.)

## Data sources

Lock Hunter uses the public LPU belt-explorer dataset for the catalog and rarity
counts, the public LPU Lock Bazaar feed, and public listing pages on the
marketplaces it searches. It reads your own lpubelts.com profile (and any profile
you explicitly compare against) to load Owned/Wishlist locks.

## License

[MIT](LICENSE) © the author. Please update the copyright line in `LICENSE` with
your name/handle before publishing.
