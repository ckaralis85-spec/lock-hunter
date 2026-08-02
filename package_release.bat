@echo off
REM ============================================================
REM  Lock Hunter - package a release for GitHub
REM
REM  Makes a clean, versioned zip containing just the finished
REM  program (LockHunter.exe + README.txt), ready to attach to a
REM  GitHub Release. GitHub also serves the raw .exe fine, so
REM  attaching either the .exe or this .zip works.
REM
REM  Run "DEVELOPER ONLY - Build EXE.bat" FIRST so that
REM  dist\LockHunter.exe exists.
REM
REM  To publish:
REM    1. Run this script (creates LockHunter-v#.#.#.zip here).
REM    2. On GitHub: Releases -> Draft a new release -> pick a tag
REM       that matches the version (e.g. v#.#.#) -> attach
REM       dist\LockHunter.exe (and/or this zip) -> Publish.
REM  The in-app update check reads the latest release tag from
REM  GitHub, so no separate version file is needed.
REM ============================================================
setlocal
cd /d "%~dp0"

REM --- read the version out of lock_hunter.py (VERSION = "x.y.z") ---
set "VER="
for /f "tokens=2 delims== " %%A in ('findstr /b /c:"VERSION = " lock_hunter.py') do set "VER=%%~A"
set VER=%VER:"=%
if "%VER%"=="" (
  echo Could not read VERSION from lock_hunter.py
  pause & exit /b 1
)

if not exist "dist\LockHunter.exe" (
  echo.
  echo   ERROR: dist\LockHunter.exe was not found.
  echo   Run "DEVELOPER ONLY - Build EXE.bat" first, then run this again.
  echo.
  pause & exit /b 1
)

set "NAME=LockHunter-v%VER%"
echo Packaging %NAME%.zip  (LockHunter.exe + README.txt)...

set "PS1=%TEMP%\lockhunter_pack.ps1"
set "OUTZIP=%~dp0%NAME%.zip"

> "%PS1%" echo $ErrorActionPreference = 'Stop'
>>"%PS1%" echo $src = '%~dp0'
>>"%PS1%" echo $out = '%OUTZIP%'
>>"%PS1%" echo if (Test-Path $out) { Remove-Item $out -Force }
>>"%PS1%" echo $stage = Join-Path $env:TEMP 'lockhunter_stage'
>>"%PS1%" echo if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
>>"%PS1%" echo New-Item -ItemType Directory -Path $stage ^| Out-Null
>>"%PS1%" echo Copy-Item (Join-Path $src 'dist\LockHunter.exe') $stage -Force
>>"%PS1%" echo if (Test-Path (Join-Path $src 'README.txt')) { Copy-Item (Join-Path $src 'README.txt') $stage -Force }
>>"%PS1%" echo Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $out -Force
>>"%PS1%" echo Remove-Item $stage -Recurse -Force
>>"%PS1%" echo Write-Host ('Created: ' + $out)

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%"
set "RC=%ERRORLEVEL%"
del /f /q "%PS1%" >nul 2>&1

if not "%RC%"=="0" (
  echo.
  echo FAILED to package the release ^(error %RC%^).
) else (
  echo.
  echo Done. Attach this file to a GitHub Release:
  echo   %OUTZIP%
  echo ^(or just attach dist\LockHunter.exe directly^).
)
pause
endlocal
