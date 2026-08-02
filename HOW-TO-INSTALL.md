# How to Download and Run Lock Hunter

Lock Hunter is a free Windows program. There's nothing to install and it
doesn't need any other software — it's a single file you download and
double-click. The whole thing takes about two minutes. Windows will show a
couple of warnings that look alarming but are completely normal for a small
independent app; the steps below walk you through each one.

**You'll need:** a Windows PC (this app does not run on Mac, iPhone, or
Android).

## Step 1 — Open the download page

Click this link (or paste it into your web browser):

**https://github.com/ckaralis85-spec/lock-hunter/releases/latest**

This opens a page on GitHub — the website where the program is stored. You
don't need an account and you don't need to sign in.

## Step 2 — Find the download file

Scroll down until you see a section called **Assets**. If it looks collapsed,
click the word **Assets** (there's a small triangle ▸ next to it) to expand it.

In the list, find the file named exactly:

**LockHunter.exe**

Click it — the download starts.

> **Important:** You may also see items called **"Source code (zip)"** and
> **"Source code (tar.gz)."** Ignore those — they're for programmers and won't
> run the app. The only file you want is **LockHunter.exe**.

## Step 3 — Tell your browser to keep the file

Because Lock Hunter is a small independent app (not from a big company), your
browser may pause and warn you before saving it — something like *"LockHunter.exe
isn't commonly downloaded"* or *"could harm your device."* This is automatic
for any lesser-known program; it doesn't mean anything is wrong.

To continue:
- Look for the download at the **top-right of your browser** (or along the
  bottom).
- If it shows a warning, click the small **three dots (⋯)** or the **arrow (▾)**
  next to the file name, then choose **Keep** (you may need **Keep anyway** or
  **Show more → Keep** to confirm).

The file finishes downloading — by default into your **Downloads** folder.

## Step 4 — Open Lock Hunter

Find the downloaded **LockHunter.exe** (click it in your browser's download
list, or open your **Downloads** folder). **Double-click it** to start.

## Step 5 — Get past the blue "Windows protected your PC" screen

The **first time** you run it, Windows will likely show a blue box:

> **Windows protected your PC**
> Microsoft Defender SmartScreen prevented an unrecognized app from starting…

**Don't worry — this is expected, and it's the last step.** Windows shows this
for *any* new app it hasn't seen often yet. To continue:

1. Click the small text link **More info** (just above or below the buttons —
   easy to miss).
2. A new button appears: **Run anyway**. Click it.

Lock Hunter opens, and **you won't have to do this again** on this computer —
Windows only asks the first time.

## If your antivirus complains

Occasionally, antivirus software flags a small independent app out of caution
— a "false alarm" that's common for programs built this way. If it happens and
the app won't open:
- Open your antivirus, look in **Quarantine** or **Protection history**, find
  **LockHunter.exe**, and choose **Restore** and/or **Allow**.
- If you're not comfortable doing that, it's completely fine to skip the app.
- (The program's full source code is public in this repository, so anyone
  technical can confirm it's safe.)

## Make it easy to open next time (optional)

1. Drag **LockHunter.exe** out of Downloads onto your **Desktop** so it doesn't
   get lost.
2. For a shortcut: **right-click** the file → **Show more options** (on Windows
   11) → **Send to** → **Desktop (create shortcut)**.

## Getting updates later

When a new version comes out, Lock Hunter quietly tells you inside the app. To
update, return to the same link and download the newest **LockHunter.exe** the
same way:

**https://github.com/ckaralis85-spec/lock-hunter/releases/latest**

Replace the old file with the new one (or just keep the newest). Your settings
and saved collection stay intact.

## "Failed to remove temporary directory: …\Temp\_MEIxxxxxx"

If you see this warning as Lock Hunter closes, nothing is broken and nothing is
lost. It comes from the packaging layer, not from Lock Hunter: a single-file
`.exe` unpacks itself into a `_MEIxxxxxx` folder in your Temp directory every
time it runs and deletes that folder on exit, and the warning means something
still had the folder open at that moment. Click **OK** and carry on.

The causes inside Lock Hunter's control are fixed — it no longer sits in that
folder while it runs, it doesn't hand the folder to browser windows it opens
for you, and it clears out leftovers from earlier runs at startup. Antivirus
software scanning the folder while Windows is deleting it can still trigger the
warning occasionally.

If it keeps happening and you'd rather it never did, build the **folder**
version instead — it unpacks nothing at run time, so there is nothing to clean
up, and it starts faster. Run:

```
"DEVELOPER ONLY - Build EXE.bat" onedir
```

That produces `dist\LockHunter\` instead of one file. Keep the whole folder
together; `LockHunter.exe` inside it will not run on its own.

## Quick help

- **I don't see LockHunter.exe.** Make sure you expanded the **Assets** section
  and you're on the *releases* page (link above). Don't download the "Source
  code" files.
- **The download keeps getting blocked.** Use the **three dots (⋯)** next to
  the download and choose **Keep / Keep anyway**.
- **Double-clicking does nothing / a warning appears.** Do **Step 5** — click
  **More info**, then **Run anyway**.
- **It says it can't run on my device.** Lock Hunter is Windows-only; it won't
  open on a Mac, iPhone, or Android.
