============================================================
 LOCK HUNTER  -  README
============================================================

Lock Hunter is a Windows app for lock collectors. It finds
locks for sale across dozens of marketplaces worldwide, built
around the official LPU (Lockpickers United) belt catalog from
lpubelts.com.

------------------------------------------------------------
 DISCLAIMER
------------------------------------------------------------

Lock Hunter is a personal, hobbyist tool provided "as is",
without warranty of any kind. It is not affiliated with,
endorsed by, or officially connected to Lockpickers United
(LPU), lpubelts.com, eBay, or any of the marketplaces it
searches. It queries publicly reachable listing pages and
public LPU data on your behalf.

You are responsible for using it in line with the terms of
service of each website it accesses and with any applicable
laws in your location. Use it respectfully: don't hammer
sites, and stop if a site asks you to. The author accepts no
liability for how the tool is used.

------------------------------------------------------------
 OPEN SOURCE
------------------------------------------------------------

Lock Hunter is open source. The full Python source ships in
this folder (lock_hunter.py) and is published publicly so
anyone can read exactly what it does, build the .exe
themselves, or contribute. See LICENSE for terms. If you
don't want to trust a downloaded .exe, you can run the
source directly with Python (see "FOR THE DEVELOPER" below).


------------------------------------------------------------
 1. WHAT IT CAN DO
------------------------------------------------------------

* Live search for any LPU-ranked lock (900+ lock catalog) or
  custom entries across 45+ marketplaces in 30+ countries.
  All the marketplaces are searched AT THE SAME TIME - and
  eBay runs alongside the sweep - so a full hunt takes
  seconds, not minutes.
* Full belt catalog with instant photos, exact Black 1-5
  sub-tiers, and a Rarity column (shown as stars) based on how
  many LPU members own each lock - sort it to hunt the rarest
  first.
* Tracks YOUR collection: Owned and Wishlist, imported
  automatically from your lpubelts.com profile.
* One-click "Search for Wishlist Locks" - hunts every lock on
  your wishlist in a single run. Or flag locks as PRIORITY
  (right-click them on the Locks tab) and hunt just your
  chase list - priority finds come back blue, pinned to the
  top of the results.
* A "price value" flag that learns over time: every search
  files prices into a local history, and once a lock has been
  seen at least 4 times, any listing at or below 80% of its
  median price gets a green "deal" mark. Fresh installs flag
  nothing yet - it needs your hunts to build the evidence.
* Compare tab - paste any collector's profile link for a full
  TWO-WAY trade check: which locks they own that are on your
  wishlist, and which locks you own that are on theirs.
* On startup it quietly checks for a newer version (once a
  day) and tells you when NEW Lock Bazaar listings match your
  wishlist since you last opened it.
* Smart filters to cut junk results, CSV / Excel exports.
* OPTIONAL AI web search (off by default): can also ask an
  Anthropic (Claude) AI model to web-search for a lock. This is
  NOT free - it uses YOUR own Anthropic API key and costs a small
  amount of API credit per run. The normal search is completely
  free.


------------------------------------------------------------
 2. INSTALLING  (the easy way - no Python needed)
------------------------------------------------------------

You will be given a file named:

        LockHunter.exe

That single file IS the whole program. It has everything it
needs built in - there is NOTHING to install and you do NOT
need Python.

1. Save LockHunter.exe somewhere you'll find it (your Desktop
   is fine). If it came in a zip, right-click the zip, choose
   "Extract All...", and take the .exe out.

2. Double-click LockHunter.exe to run it.

   The first time, Windows SmartScreen may show a blue "Windows
   protected your PC" box (this happens with any new app that
   isn't code-signed). Click "More info", then "Run anyway".
   You only have to do this once.

To UPDATE later, just replace the old LockHunter.exe with the
new one. Your settings, collection and database are stored
separately (in %USERPROFILE%\.lockhunter) and carry over
automatically.


------------------------------------------------------------
 3. RUNNING LOCK HUNTER
------------------------------------------------------------

Double-click LockHunter.exe (or make a Desktop shortcut to it:
right-click the .exe -> Send to -> Desktop).

On first launch it will ask for your lpubelts.com profile link
so it can import your Owned locks and Wishlist automatically.
(On lpubelts.com open your profile and copy the share URL.) It
may also offer to update the lock catalog - say Yes; the
catalog comes straight from the Belt Explorer's own dataset,
which brings the exact Black 1-5 sub-tiers, every lock's photo,
and the owner counts in one go.

A few seconds after starting, Lock Hunter also quietly checks
for a newer app version (at most once a day, silent unless one
exists) and compares the Lock Bazaar against your last visit -
if new listings match your wishlist, you get a small note.


------------------------------------------------------------
 4. THE TABS
------------------------------------------------------------

SEARCH - the main hunt screen.

  Pick a Belt (optional), start typing the Lock name (it
  auto-completes from the catalog - or type anything else you
  want to hunt for), choose the Sales type (Auction /
  secondhand, Website sales, or Both), then press "Search
  live". Searches always cover BOTH new and used items. All
  marketplaces are probed at the same time, with eBay running
  alongside the sweep, so results land fast. Double-click a
  result to open the listing. The Rarity column shows each
  lock's rarity stars (same scale as the Locks tab).

  Options under the search box:
  * Exclude pickup / meetup-only - skip ads that can't ship.
  * Lock results only - filters out same-name items that are
    NOT locks (sunglasses, games, etc). Leave this ON; turn it
    off only if you think it hid something real.
  (The old "Extended search" checkbox is gone - the deeper,
  more thorough sweep is now simply always on.)

  Above the results you can filter them, hide non-shippable
  results, show a USD estimate next to foreign prices, clear
  the results, or open the activity log. "Open Lock Bazaar"
  sits under the selected lock's photo, and "Export Lock
  Search" (bottom bar) saves the results to Excel with
  clickable listing links. The toolbar has "Update LPU
  catalog" (refresh the lock list) and an "Enter/Change API
  key" link.

  RIGHT-CLICK a result row (Ctrl/Shift-click picks several)
  for: Open listing, Copy link, Remove from results (gone
  until a future scan re-finds it), and NEVER SHOW AGAIN -
  which hides those exact listings from every future scan and
  export until you press "Clear all 'Never show again'" at
  the top of the Locks tab. The Delete key = Remove. Hover a
  row for its photo; DOUBLE-CLICK opens the listing.

LOCKS - the full catalog and your collection.

  Filter with Show (All locks / Locks I own / My wishlist /
  My priorities), Belt, and the Find box. Click a lock to see
  its photo - photos come straight from the catalog, so they
  appear instantly. Double-click opens its LPU page.

  The Rarity column shows stars for how rare a lock is, based
  on how many LPU members own it (5 stars = rarest, 1 star =
  most common). Click that header to sort RAREST FIRST. The
  preview also shows the rarity and the owner count.

  The Owned and Wishlist columns show your collection; use
  "Update profile" to re-import it after you change things on
  lpubelts.com. RIGHT-CLICK any lock (or a Ctrl/Shift-picked
  group) for the quick actions most people never find:
  Search for "<name>" (a full live hunt straight from the
  catalog), Hunt the N selected locks, and Mark / un-mark as
  PRIORITY. Locks that aren't in the LPU catalog at all can
  join your priority list through the "Not on LPU?" box.

  With Show set to "My wishlist", the "Search for Wishlist
  Locks" button lights up: it live-searches EVERY lock on your
  wishlist in one batch. It first asks "Locks only / Show
  everything / Cancel" so you choose how strictly to filter
  that run. It can take a while and return a lot - normal.

COMPARE - a two-way trade check with any collector.

  Paste another collector's lpubelts.com profile link and
  press "Compare". You get TWO groups: locks THEY own that are
  on YOUR wishlist, and locks YOU own that are on THEIR
  wishlist - everything you need to build a trade offer, with
  belts (including Black tiers). Save as CSV / Excel or Copy
  to clipboard; exports include a "Who has it" column.
  DOUBLE-CLICK any lock in the comparison (or right-click ->
  Open LPU page) to see that lock on lpubelts.com while you
  weigh the trade. Don't have someone's link? "LPU profile
  search" (top right) opens the LPU locks leaderboard - find
  the collector, open their profile, copy the URL.

COLLECTION - your collection at a glance, offline.

  Belt-by-belt completion bars in LPU colours, your rarest
  owned and rarest missing, and "Hunt next" - your wishlist
  ranked by how gettable each lock is from your own search
  history. DOUBLE-CLICK a Hunt-next row to jump straight into
  a live search for that lock.

OWNERS - who owns a lock, and your best trade partners.

  Search any lock to see which LPU collectors own it, plus
  "Top wishlist owners" (who owns most of YOUR wishlist) and
  "Top Bazaar sellers". The rows are live - and this is the
  bit almost nobody finds: RIGHT-CLICK a collector for
  "Compare trades with them" (runs the full two-way Compare
  without hunting down their profile link) or "Open their LPU
  profile". DOUBLE-CLICK opens their profile too.


------------------------------------------------------------
 5. THE DIFFERENT WAYS TO SEARCH (CHEAT SHEET)
------------------------------------------------------------

1. Single lock, live: Search tab, pick or type the lock,
   press "Search live".
2. Whole wishlist at once: Locks tab, set Show to "My
   wishlist", press "Search for Wishlist Locks" ("Only new
   searches" repeats it but shows only what's new since last
   time).
3. THE PRIORITY HUNT - your daily driver: right-click the
   locks you're actively chasing -> "Mark as priority" (add
   off-catalog locks via the "Not on LPU?" box), then set
   Show to "My priorities" and press "Hunt these locks". One
   click sweeps your whole chase list - owned or not - and
   priority finds come back BLUE, pinned to the top of the
   results.
4. Any set of locks: pick rows with Ctrl/Shift-click (any
   view, any belt filter) and press "Hunt these locks" - the
   button always states its real scope.
5. Straight from the catalog: Locks tab, right-click a lock,
   Search for "<name>".
6. Compare a collector: Compare tab with their profile link -
   two-way, so you see what to offer them back.


------------------------------------------------------------
 6. WHERE YOUR DATA LIVES / IF SOMETHING BREAKS
------------------------------------------------------------

Your database, settings and logs live in:

    %USERPROFILE%\.lockhunter\

That folder survives updates - replacing the .exe never
touches your collection.

* App crash: a crash_log.txt is written in the folder above -
  send it to Ferf. You can also click "Help" at the bottom of
  the window: it builds a full diagnostic report, copies it
  to your clipboard, and opens a pre-filled GitHub issue page
  in your browser - describe the problem, press Ctrl+V to
  paste the report, and submit. Nothing is sent until you
  post the issue yourself.
* Black locks show plain "Black" instead of Black 1-5, photos
  or owner counts are missing, or a lock is missing: press
  "Update LPU catalog" (Search tab toolbar) once.


------------------------------------------------------------
 7. FOR THE DEVELOPER - BUILDING THE .EXE
------------------------------------------------------------

(End users can ignore this section - it's how the .exe above
gets made.)

New computers RUN LockHunter.exe. They never build anything.
The build happens ONCE, on the developer's Windows PC, to
CREATE that .exe:

  1. On a Windows PC that has Python 3, extract this zip.
  2. Double-click  "DEVELOPER ONLY - Build EXE.bat".
  3. It freezes everything into  dist\LockHunter.exe  using
     PyInstaller (bundling a private Python runtime inside).
     This build step is the ONLY thing that needs Python, and
     only on this one PC - the .exe it makes needs none.
  4. Hand out that dist\LockHunter.exe - it runs on any
     Windows PC with no Python and no install.

Two build scripts ship in the zip, for the developer only:
  * "DEVELOPER ONLY - Build EXE.bat" - the recommended path. Freezes
    the standalone dist\LockHunter.exe to hand out (above).
  * "Install LockHunter.bat"   - older from-source route that
    builds AND installs on a machine that already has Python.
Both need Python on the BUILD machine; neither is needed by
the people you give LockHunter.exe to.

Happy hunting!

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Still reading? Good. The first five people who read this
README and tag me in Discord with "@Ferf Lockhunter is
bananas! B-A-N-A-N-A-S!" get a free mystery lock.
