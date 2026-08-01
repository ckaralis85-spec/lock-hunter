@echo off
REM ============================================================
REM  Lock Hunter - one-click Windows installer
REM  Requires: Python 3.9+ installed from python.org (with pip)
REM  Output:   dist\LockHunter.exe  (single file, no console)
REM ============================================================
cd /d "%~dp0"

REM If lock_hunter.py isn't sitting next to this script, the program files were
REM never unpacked - almost always because the .bat was launched from INSIDE
REM the .zip (Windows extracts only the .bat to a temp folder). Bail clearly.
if not exist "%~dp0lock_hunter.py" goto :not_extracted

REM --- Start a build log that can be copy-pasted / sent if anything fails ---
set "LOG=%~dp0lockhunter_build_log.txt"
>"%LOG%" echo ==================== Lock Hunter BUILD log ====================
>>"%LOG%" echo Date: %DATE% %TIME%
>>"%LOG%" ver

REM --- Find a working Python: the py launcher first (it works even when
REM     python.exe was NOT added to PATH), then python, then python3. ---
set "PYEXE="
py -3 --version >nul 2>&1 && set "PYEXE=py -3"
if not defined PYEXE ( py --version >nul 2>&1 && set "PYEXE=py" )
if not defined PYEXE ( python --version >nul 2>&1 && set "PYEXE=python" )
if not defined PYEXE ( python3 --version >nul 2>&1 && set "PYEXE=python3" )
REM Still nothing on PATH? Scan the usual install folders (covers a python.org
REM install where "Add to PATH" was NOT ticked and the py launcher is absent).
if not defined PYEXE call :scan_python "%LOCALAPPDATA%\Programs\Python"
if not defined PYEXE call :scan_python "%PROGRAMFILES%"
if not defined PYEXE call :scan_python "%PROGRAMFILES(x86)%"
if not defined PYEXE call :scan_python "%SystemDrive%"
if not defined PYEXE goto :no_python
echo Using Python: %PYEXE%
>>"%LOG%" echo Python: %PYEXE%
%PYEXE% --version >>"%LOG%" 2>&1

echo Creating virtual environment...
>>"%LOG%" echo --- creating virtual environment ---
%PYEXE% -m venv .venv >>"%LOG%" 2>&1
call .venv\Scripts\activate.bat

echo Installing dependencies (details go to the log; this can take a minute)...
>>"%LOG%" echo --- pip install ---
pip install --upgrade pip >>"%LOG%" 2>&1
pip install requests pillow openpyxl pyinstaller >>"%LOG%" 2>&1
if errorlevel 1 goto :dep_failed

echo Cleaning previous build output...
REM Remove old build artifacts so each build is fresh and no stale exe lingers.
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist LockHunter.spec del /f /q LockHunter.spec

REM Build the PyInstaller options. Prefer a real assets\ folder if present.
REM Otherwise, extract the icon that's EMBEDDED inside lock_hunter.py so the
REM built .exe still gets the proper LPU file icon with no assets folder needed.
set ICON_OPT=
set DATA_OPT=
if exist "assets" (
  set DATA_OPT=--add-data "assets;assets"
)
if exist "assets\lpu_icon.ico" (
  set ICON_OPT=--icon "assets\lpu_icon.ico"
) else (
  echo   assets\lpu_icon.ico not found - extracting the icon embedded in
  echo   lock_hunter.py so the .exe still gets the LPU icon...
  python lock_hunter.py --extract-icon "_built_icon.ico"
  if exist "_built_icon.ico" (
    set ICON_OPT=--icon "_built_icon.ico"
    echo   Extracted the embedded LPU icon.
  ) else (
    echo   NOTE: could not extract the embedded icon; building with default icon.
  )
)

echo Installing Lock Hunter (this can take a minute or two)...
>>"%LOG%" echo --- pyinstaller ---
python lock_hunter.py --write-version-file "version_info.txt" >nul 2>&1
set "VER_OPT="
if exist "version_info.txt" set VER_OPT=--version-file "version_info.txt"
pyinstaller --onefile --windowed --name LockHunter ^
  --clean --noupx ^
  %VER_OPT% ^
  %ICON_OPT% ^
  %DATA_OPT% ^
  --hidden-import openpyxl ^
  --hidden-import openpyxl.cell._writer ^
  lock_hunter.py >>"%LOG%" 2>&1

REM clean up the temp icon we may have extracted
if exist "_built_icon.ico" del /f /q "_built_icon.ico"
if exist "version_info.txt" del /f /q "version_info.txt"

REM NOTE: user data (database, log, saved API key/profile) lives in
REM   %USERPROFILE%\.lockhunter\   and is NOT touched by builds or installs,
REM   so it automatically carries over from one version to the next.

if not exist "dist\LockHunter.exe" goto :build_failed

echo.
echo ============================================================
echo   SUCCESS - Lock Hunter has been installed.
echo ============================================================
echo.
echo   The program file is here:
echo     "%~dp0dist\LockHunter.exe"
echo.
echo   This is a compiler, not an installer - there is no setup
echo   wizard. The single .exe above IS the whole program; just
echo   run it. Your settings and collection are saved separately
echo   in  %%USERPROFILE%%\.lockhunter\  and carry over between builds.
echo.

REM --- Create/refresh the Desktop shortcut (always replaces any old one) ---
REM Resolve the REAL Desktop folder. On many PCs the Desktop is redirected into
REM OneDrive, so %USERPROFILE%\Desktop can be the wrong place - ask Windows.
for /f "usebackq delims=" %%D in (`powershell -NoProfile -Command "[Environment]::GetFolderPath('Desktop')"`) do set "DESKTOP_DIR=%%D"
if not defined DESKTOP_DIR set "DESKTOP_DIR=%USERPROFILE%\Desktop"
set "EXE_PATH=%~dp0dist\LockHunter.exe"
set "LNK_PATH=%DESKTOP_DIR%\Lock Hunter.lnk"
REM ALWAYS replace existing shortcuts - and not just this exact name: old
REM installs and "Send to > Desktop" leave variants like "LockHunter.exe -
REM Shortcut.lnk" or "Lock Hunter (2).lnk", which is how duplicates happen.
REM Sweep EVERY Lock Hunter shortcut variant from every Desktop Windows
REM might be showing (resolved Desktop, classic user Desktop, OneDrive,
REM Public), then create ONE canonical "Lock Hunter.lnk" below.
for %%B in ("%DESKTOP_DIR%" "%USERPROFILE%\Desktop" "%USERPROFILE%\OneDrive\Desktop" "%PUBLIC%\Desktop") do (
  del /f /q "%%~B\Lock Hunter*.lnk" >nul 2>&1
  del /f /q "%%~B\LockHunter*.lnk" >nul 2>&1
)

REM Put the icon in a STABLE local folder (never OneDrive / online-only), so the
REM shortcut can always resolve it. %USERPROFILE%\.lockhunter is local app data.
if not exist "assets\lpu_icon.ico" python lock_hunter.py --extract-icon "assets\lpu_icon.ico" >nul 2>&1
set "ICON_DIR=%USERPROFILE%\.lockhunter\assets"
if not exist "%ICON_DIR%" mkdir "%ICON_DIR%" >nul 2>&1
REM Content-hash the icon and store it under a NAME THAT CHANGES with the
REM icon (icon_<hash>.ico). Windows caches shortcut icons by PATH, so
REM rewriting the same lpu_icon.ico path keeps showing the OLD cached image;
REM a brand-new path has no cache entry and renders correctly at once.
set "ICOHASH="
for /f %%H in ('powershell -NoProfile -Command "(Get-FileHash -Algorithm MD5 'assets\lpu_icon.ico').Hash.Substring(0,8).ToLower()" 2^>nul') do set "ICOHASH=%%H"
if defined ICOHASH (
  set "ICON_FILE=%ICON_DIR%\icon_%ICOHASH%.ico"
) else (
  set "ICON_FILE=%ICON_DIR%\lpu_icon.ico"
)
del /f /q "%ICON_DIR%\icon_*.ico" >nul 2>&1
copy /y "assets\lpu_icon.ico" "%ICON_FILE%" >nul 2>&1
REM keep the legacy path fresh too, for any old shortcut still aimed at it
copy /y "assets\lpu_icon.ico" "%ICON_DIR%\lpu_icon.ico" >nul 2>&1

REM Create the shortcut. Set IconLocation explicitly to the stable icon file so
REM it doesn't depend on OneDrive having the .exe downloaded locally.
set "ICON_ARG="
if exist "%ICON_FILE%" set "ICON_ARG=$s.IconLocation='%ICON_FILE%,0';"
powershell -NoProfile -Command "$w=New-Object -ComObject WScript.Shell; $s=$w.CreateShortcut('%LNK_PATH%'); $s.TargetPath='%EXE_PATH%'; $s.WorkingDirectory='%~dp0dist'; %ICON_ARG% $s.Save()"

REM Nudge Windows to refresh its icon cache so the new icon shows immediately.
powershell -NoProfile -Command "ie4uinit.exe -show" >nul 2>&1

if exist "%LNK_PATH%" (
  echo   Done - "Lock Hunter" is now on your Desktop.
  echo   ^(If the icon still looks generic, it's Windows' icon cache - it will
  echo    refresh shortly, or after a sign-out/restart.^)
) else (
  echo   Couldn't create the shortcut automatically; you can right-click
  echo   the exe in the folder and choose "Send to ^> Desktop" instead.
)

REM Build succeeded. Show a brief alert (auto-dismisses after ~15s, so the
REM window still closes on its own), then exit. Each PowerShell call sits on its
REM own line - NOT inside a parentheses block - so its ( ) are safe.
if not exist "%LNK_PATH%" goto :ok_noshortcut
powershell -NoProfile -Command "(New-Object -ComObject WScript.Shell).Popup('Lock Hunter was installed successfully.  A shortcut is on your Desktop.',15,'Lock Hunter',64)" >nul 2>&1
goto :ok_done
:ok_noshortcut
powershell -NoProfile -Command "(New-Object -ComObject WScript.Shell).Popup('Lock Hunter was installed successfully.  It is in the dist folder (a Desktop shortcut could not be created).',15,'Lock Hunter',64)" >nul 2>&1
:ok_done
exit /b 0

:not_extracted
echo.
echo ============================================================
echo    PLEASE EXTRACT THE ZIP FIRST
echo ============================================================
echo.
echo    The program file (lock_hunter.py) is not next to this
echo    script, so it looks like you launched this from INSIDE the
echo    .zip file. Windows only unpacks the .bat you double-click,
echo    not the rest of the program - so the build cannot find it.
echo.
echo    Do this instead:
echo      1. Close this window.
echo      2. Find the downloaded  LockHunter-vX.zip  file.
echo      3. RIGHT-CLICK it and choose  "Extract All..."  then click
echo         Extract.
echo      4. Open the NEW folder that was created (not the zip).
echo      5. Double-click  %~nx0  from inside that extracted folder.
echo.
pause
exit /b 1

:dep_failed
>>"%LOG%" echo RESULT: dependency install failed (see the pip output above).
echo.
echo ============================================================
echo    COULD NOT INSTALL THE REQUIRED PYTHON PACKAGES
echo ============================================================
echo.
echo    This usually means no internet connection, a proxy/firewall
echo    blocking pip, or a pip problem. A log was saved here:
echo        %LOG%
echo.
echo    The log has been opened for you - please send it to Ferf so
echo    it can be fixed.
echo.
start "" notepad "%LOG%"
powershell -NoProfile -Command "(New-Object -ComObject WScript.Shell).Popup('Lock Hunter could not install its dependencies, so it could not be installed.  The log file has been opened - please send it to Ferf so it can be fixed.',0,'Lock Hunter - build failed',48)" >nul 2>&1
pause
exit /b 1

:build_failed
>>"%LOG%" echo RESULT: build finished but dist\LockHunter.exe is missing.
echo.
echo ============================================================
echo    INSTALL FAILED
echo ============================================================
echo.
echo    A log of exactly what happened was saved here:
echo        %LOG%
echo.
echo    The log has been opened for you - please send it to Ferf so
echo    it can be fixed.
echo.
start "" notepad "%LOG%"
powershell -NoProfile -Command "(New-Object -ComObject WScript.Shell).Popup('Lock Hunter could not be installed.  The log file has been opened - please send it to Ferf so it can be fixed.',0,'Lock Hunter - build failed',48)" >nul 2>&1
pause
exit /b 1

:no_python
>>"%LOG%" echo RESULT: Python not found (checked py, python, python3, common folders).
echo.
echo ============================================================
echo    PYTHON IS NOT INSTALLED ON THIS COMPUTER
echo ============================================================
echo.
echo    To build or run Lock Hunter from source you need Python 3.
echo    I checked the py launcher, "python", "python3", and the usual
echo    install folders - none were found.
echo.
echo    -------- HOW TO INSTALL PYTHON  (about 3 minutes) --------
echo.
echo      1) Open   https://www.python.org/downloads/
echo         (this window can open it for you - see the prompt below).
echo.
echo      2) Click the big yellow "Download Python 3.x" button. It
echo         picks the right version for Windows automatically.
echo.
echo      3) Run the file it downloads. It lands in your Downloads
echo         folder with a name like   python-3.13.x-amd64.exe
echo.
echo      4) ** IMPORTANT ** On the FIRST installer screen, tick the
echo         checkbox at the BOTTOM that says
echo                "Add python.exe to PATH"
echo         BEFORE clicking Install. This is the step most people
echo         miss, and it is exactly why "python" is not found here.
echo.
echo      5) Click "Install Now", let it finish, then click Close.
echo.
echo      6) Come back here, CLOSE this window, open a NEW one, and
echo         run   %~nx0   again. A brand-new window is required so
echo         Windows sees the Python you just installed.
echo.
echo    -------- Don't want to install Python? --------
echo.
echo      You do NOT need Python just to RUN Lock Hunter. On a PC
echo      where you already built it, copy the finished program
echo             dist\LockHunter.exe
echo      to this computer - that single .exe runs on its own, with
echo      no Python installed.
echo.
choice /c YN /n /m "    Open the Python download page in your browser now? [Y/N] "
if not errorlevel 2 start "" "https://www.python.org/downloads/"
echo.
pause
exit /b 1

REM ==================== subroutines ====================
REM :scan_python "<root folder>"  - if a Python3xx\python.exe exists under the
REM given root, prepend it to PATH (handles spaces in the path) and set
REM PYEXE=python. Returns immediately on the first match.
:scan_python
for /d %%D in ("%~1\Python3*") do (
  if exist "%%D\python.exe" (
    set "PATH=%%D;%%D\Scripts;%PATH%"
    set "PYEXE=python"
    goto :eof
  )
)
goto :eof
