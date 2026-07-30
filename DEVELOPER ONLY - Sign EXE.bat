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
"!ST!" sign /tr http://time.certum.pl /td sha256 /fd sha256 /a "dist\LockHunter.exe"
if errorlevel 1 (
  echo.
  echo   SIGNING FAILED.
  echo   Most common cause: SimplySign Desktop is not connected.
  echo   Open its tray icon, "Connect to SimplySign", enter the
  echo   6-digit code from the mobile app, then run this again.
  echo.
  pause & exit /b 1
)

echo.
echo Verifying the signature...
"!ST!" verify /pa "dist\LockHunter.exe"
if errorlevel 1 (
  echo   Verification reported a problem - check the output above.
) else (
  echo.
  echo   SUCCESS: dist\LockHunter.exe is signed and timestamped.
  echo   Now run package_release.bat, and attach the SIGNED exe
  echo   ^(this same file^) to the GitHub release.
)
pause
endlocal
