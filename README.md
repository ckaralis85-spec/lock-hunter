# Lock Hunter

A Windows desktop app for lock collectors. It finds locks for sale across dozens
of marketplaces worldwide, built around the official
[LPU (Lockpickers United) belt catalog](https://lpubelts.com).

> ⚠️ **Please read the [Disclaimer](DISCLAIMER.md).** Lock Hunter is a personal,
> hobbyist tool, not affiliated with LPU, lpubelts.com, eBay, or any marketplace.
> You are responsible for using it in line with each site's terms of service.

## What it does

Lock Hunter has five tabs — **Search**, **Locks**, **Collection**, **Compare**,
and **Owners** — built around the ~900-lock LPU belt catalog and your own
lpubelts.com collection.

### Live search

Search any LPU-ranked lock or your own custom terms and Lock Hunter queries, all
at once:

- **eBay** — both the official eBay Browse API (when you've added keys) and a
  direct page scrape, run together.
- **45+ national marketplaces in 30+ countries** — Catawiki, Kleinanzeigen,
  Leboncoin, Marktplaats, 2dehands, Ricardo, Tradera, Blocket, Willhaben, Subito,
  Delcampe, Etsy, Wallapop, Milanuncios, Finn, Tori, Huuto, Gumtree (UK/AU),
  OLX, Allegro (Poland), Avito, Yad2, Buyee, Yahoo Auctions Japan, Mercari Japan,
  Taobao, Mercado Libre (Latin America), Vinted, Trade Me (New Zealand),
  ShopGoodwill, GovDeals, LiveAuctioneers, DoneDeal, DBA, Osta, SS.com, Skelbiu,
  Kufar, Bazoš, Jófogás, Njuškalo, KupujemProdajem, Maltapark, Sahibinden,
  Bazaraki and more — each queried directly, no API key needed.
- **The LPU Lock Bazaar** — always included, shown first in the results.
- **Facebook Marketplace** — optional, opt-in per search (public listings only,
  no login, single-lock searches).

Everything runs concurrently, so a full sweep takes seconds rather than the sum
of every site. Found listings are verified (dead and ended listings dropped)
before they reach the table. A **Sales** selector lets you limit a run to
auction/secondhand sites or website sales.

### Results you can filter after the search

The results table (Lock · Title · Price · Site · Location · Rarity) filters what's
already on screen — **change any of these on or off after a scan, with no
re-search**:

- **Lock results only** — hides same-name non-lock listings (e.g. "Sol"
  sunglasses when you're hunting the "Sol 2500" lock) and "blank key / key
  blank / key-cutting" listings that sell a key *for* the lock rather than the
  lock itself (multilingual; a lock sold *with* keys is kept). *On by default.*
- **Only eBay that ships to me** — set your country, and this hides eBay
  listings that won't ship there. *Off by default.*
- **Exclude pickup / meetup-only** — hides local-pickup-only listings.
  *Off by default.*
- **Show USD estimate** — appends a `(~$…)` estimate next to foreign prices
  using live exchange rates. *Off by default.*
- **Price range ($ min–max)** — two small boxes that hide listings outside a
  USD price band (prices are normalized to USD to compare across currencies;
  listings whose price can't be read are kept).
- **Site** — a dropdown to show only one marketplace/site from the current
  results.

Two things the table now does automatically:

- **Deal score** — a listing is marked **✓ deal** (and turns green) when its
  price is at or below 80% of the median price seen for that lock across your
  search history, so genuine bargains stand out. It only kicks in once there's
  enough price history for a lock to judge.
- **Foreign-title glossary** — foreign listing titles get a compact English
  gloss of common lock/condition terms appended in brackets (e.g. *… · [padlock,
  used, with key]*), so international results are readable at a glance. It's a
  display aid only and never changes what's stored or filtered.

Hover a row to preview the listing's photo; double-click to open it; click any
column header to sort. Set your **country** on the Search tab and eBay's own API
results are pre-narrowed to items that deliver there. The Excel export honors all
the on-screen filters, so it matches exactly what you see.

### Full belt catalog (Locks tab)

The complete catalog with photos, Black 1–5 sub-tiers, and a **Rarity** column
of stars based on how many LPU members own each lock (5★ extremely rare → 1★ very
common), all sortable. Switch between **All locks**, **Locks I own**, and **My
wishlist**, filter by belt, and search by name. **Update profile** imports your
Owned and Wishlist locks straight from your lpubelts.com profile.

### Hunt your wishlist — or any set of locks

Three buttons on the Locks tab run the free search (eBay + all marketplaces +
Bazaar, no API credits) across a whole list of locks in one run:

- **Search for Wishlist Locks** — every wishlist lock in one run.
- **Only new searches** — the same hunt, but shows only listings that are new
  since your last wishlist search (greyed out until a first run sets a baseline).
- **Hunt these locks** — a batch hunt of *any* set: select rows with
  Ctrl/Shift-click to hunt exactly those, or select nothing to hunt everything
  currently shown by the Show/Belt/Find filters. "Every Purple I don't own" is
  just Belt: Purple + this button — locks you already own are skipped
  automatically (unless you're in the "Locks I own" view, where hunting your
  own locks is clearly the point). Also available from the right-click menu
  when several rows are selected. Batch hunts never disturb the wishlist's
  "only new" baseline.

### Collection dashboard (Collection tab)

A local, at-a-glance view of your collection, styled after the lpubelts.com belt
layout — no network needed, it reads only your imported collection and the
catalog:

- **Belt progress** — every belt from White to Black in its official LPU colour,
  each with a completion bar showing how many you own of that belt (e.g.
  *Blue — 12 / 40 (30%)*), plus an overall "% of the catalog owned" line and your
  Owned / Wishlist totals.
- **Hunt next** — your wishlist ranked by how *gettable* each lock is: how often
  it has actually turned up in your past searches (times seen), its typical price,
  and its rarity, boiled down to a plain verdict — **Grab it** / **Shows up
  often** for common locks you see a lot, **Keep hunting** for occasional ones,
  and **Grail — pounce** for the rare ones you've never seen. Double-click a row
  to jump straight to a search for that lock.
- **Rarest you own** and **Rarest you're missing** — two side-by-side lists that
  surface your scarcest locks and the rarest catalog locks still absent from your
  collection.

The dashboard refreshes automatically whenever you import your profile or clear
your data, so it always reflects your current collection.

### Compare tab

Paste any collector's lpubelts.com profile link for a two-way trade check: what
they own that's on your wishlist, and what you own that's on theirs.

### Owners tab

Search a lock to see which LPU collectors own it, or use:

- **Top wishlist owners** — the collectors who own the most locks from your
  wishlist.
- **Top Bazaar sellers** — the Lock Bazaar sellers who currently have the most
  of your wishlist listed for sale.

### More

- **New-on-the-Bazaar alerts** — on startup, Lock Hunter quietly checks the Lock
  Bazaar and flags new listings that match your wishlist.
- **Excel export** — Lock name, Rarity, Title, Price, Price (USD), Site, Seller,
  and a clickable listing link, from the Search, Owners, and Compare views.
- **Daily update check** — tells you inside the app when a new version is out.
- **Remembers your window** — size, position, maximized state and your last
  results-sort choice are restored on the next launch (and clamped back
  on-screen if the monitor they were on is gone).
- **Self-maintaining** — the app log and thumbnail cache cap themselves at
  startup (≈2 MB / ≈200 MB), so months of hunting never silently eat disk.
- **Optional AI web search** (off by default) — can also ask an Anthropic
  (Claude) model to web-search for a lock. This is **not free**: it uses **your
  own** Anthropic API key and costs a small amount of API credit per run (usually
  a few US cents). The normal search is completely free.

Your settings, imported collection, search history, and image cache live locally
in a `.lockhunter` folder in your home directory — nothing is uploaded anywhere.

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

Dependencies (`requirements.txt`): `requests` (required), `pillow` (thumbnails),
`openpyxl` (Excel export), and `curl_cffi` (strongly recommended — gives every
scraping probe a real Chrome TLS fingerprint so marketplaces serve results
instead of bot-walling; the app still runs without it).

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

## Antivirus & browser download warnings

Chrome, SmartScreen, or an antivirus may flag the downloaded `LockHunter.exe`.
This is a **false positive** that affects most small open-source Windows apps
packed with PyInstaller: the machine-learning heuristics recognize the
PyInstaller packaging pattern (a Python app bundled into one self-extracting exe)
rather than anything in the code, and treat it with suspicion until the file
builds download reputation.

What you can do:

- **Verify, then keep.** Each release lists the exe's SHA-256 on the GitHub
  Releases page - compare it after downloading, then choose *Keep / Download
  anyway* in your browser.
- **Build it yourself.** Run `Install LockHunter.bat` from the source zip - the
  exe is compiled on your own PC from the code in this repo, so nothing is
  downloaded that a browser could flag.
- Releases are **code-signed**, and the exe carries proper Windows version
  metadata; reputation with Google/Microsoft builds automatically as the same
  signed app is downloaded over time.

If your scanner still flags it, it can be reported as a false positive to
[Google Safe Browsing](https://safebrowsing.google.com/safebrowsing/report_error/)
and [Microsoft](https://www.microsoft.com/en-us/wdsi/filesubmission).
