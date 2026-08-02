@echo off
REM ============================================================
REM  Lock Hunter - sign the built EXE (Certum / SimplySign)
REM
REM  Signs dist\LockHunter.exe with your Certum code-signing
REM  certificate and timestamps it, then verifies the signature.
REM
REM  BEFORE RUNNING (each signing session):
REM    1. Open the SimplySign Desktop app (system-tray icon) and
REM       CONNECT: right-click -> Connect to SimplySign, log in
REM       with your e-mail + the 6-digit code from the SimplySign
REM       mobile app. (The connection lasts a couple of hours.)
REM    2. Make sure dist\LockHunter.exe exists
REM       (run "DEVELOPER ONLY - Build EXE.bat" first).
REM
REM  ORDER PER RELEASE:
REM    Build EXE  ->  THIS SCRIPT  ->  package_release.bat
REM  so the zip (and whatever you attach to GitHub) contains the
REM  SIGNED exe.
REM
REM  One-time prerequisite: the Windows SDK "Signing Tools"
REM  component (provides signtool.exe).
REM ============================================================
setlocal EnableDelayedExpansion
cd /d "%~dp0"

if not exist "dist\LockHunter.exe" (
  echo.
  echo   ERROR: dist\LockHunter.exe not found.
  echo   Run "DEVELOPER ONLY - Build EXE.bat" first.
  echo.
  pause & exit /b 1
)

REM --- locate signtool.exe (PATH first, then the Windows SDK folders) ---
set "ST="
where signtool >nul 2>&1 && set "ST=signtool"
if not defined ST (
  for /f "delims=" %%F in ('dir /b /s "C:\Program Files (x86)\Windows Kits\10\bin\signtool.exe" 2^>nul ^| findstr /i "\\x64\\"') do set "ST=%%F"
)
if not defined ST (
  for /f "delims=" %%F in ('dir /b /s "C:\Program Files\Windows Kits\10\bin\signtool.exe" 2^>nul ^| findstr /i "\\x64\\"') do set "ST=%%F"
)
if not defined ST (
  echo.
  echo   ERROR: signtool.exe was not found.
  echo   Install the Windows SDK ^(only the "Windows SDK Signing Tools"
  echo   component is needed^) and run this again.
  echo.
  pause & exit /b 1
)

echo Using signtool: !ST!
echo Signing dist\LockHunter.exe ...
REM  /i Certum restricts the auto-pick to certificates ISSUED BY Certum.
REM  Without it, /a can silently grab a leftover self-signed or test
REM  certificate on the machine - the file "signs" fine but then fails
REM  verification with "terminated in a root certificate which is not
REM  trusted" and gives you zero SmartScreen benefit.
"!ST!" sign /tr http://time.certum.pl /td sha256 /fd sha256 /a /i Certum "dist\LockHunter.exe"
if errorlevel 1 (
  echo.
  echo   SIGNING FAILED.
  echo   Two common causes:
  echo     1. SimplySign Desktop is not connected. Open its tray icon,
  echo        "Connect to SimplySign", enter the 6-digit code from the
  echo        mobile app, then run this again.
  echo     2. No Certum-issued certificate was found on this PC. Connect
  echo        SimplySign first ^(it exposes the certificate^), then re-run.
  echo.
  pause & exit /b 1
)

echo.
echo Verifying the signature...
"!ST!" verify /pa "dist\LockHunter.exe"
if errorlevel 1 (
  echo.
  echo   Verification FAILED. Details of the certificate that signed it:
  echo   ------------------------------------------------------------
  "!ST!" verify /pa /v "dist\LockHunter.exe"
  echo   ------------------------------------------------------------
  echo.
  echo   How to read this:
  echo.
  echo   * If "Issued by" above shows YOUR OWN name ^(issuer = subject^),
  echo     a leftover self-signed certificate signed the file. Connect
  echo     SimplySign and run this script again - the /i Certum filter
  echo     now forces the real Certum certificate.
  echo.
  echo   * If it shows a Certum chain but still says "not trusted", this
  echo     PC is just missing Certum's root/intermediate certificates
  echo     locally. Download them from:
  echo         https://www.certum.eu/en/cert_offer_ca_certificates/
  echo     ^(Certum Trusted Network CA + the Code Signing intermediates^),
  echo     double-click each .cer, Install Certificate, Local Machine,
  echo     let Windows pick the store, then re-run this script.
  echo     End users are NOT affected either way - Windows fetches
  echo     trusted roots automatically on their machines.
  echo.
) else (
  echo.
  echo   SUCCESS: dist\LockHunter.exe is signed and timestamped.
  echo   Now run package_release.bat, and attach the SIGNED exe
  echo   ^(this same file^) to the GitHub release.
)
pause
endlocal
