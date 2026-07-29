@echo off
setlocal enabledelayedexpansion
REM ===========================================================================
REM  DEVELOPER ONLY - Build EXE.bat  -  DEVELOPER build script (you run this, not the end user)
REM ---------------------------------------------------------------------------
REM  Freezes Lock Hunter into a single standalone  dist\LockHunter.exe  using
REM  PyInstaller. That .exe bundles its own private Python runtime, so it runs
REM  on ANY Windows PC with NOTHING installed - no Python, no pip, no setup.
REM
REM  Ship  dist\LockHunter.exe  to users (drop it in the release zip). They
REM  just double-click it. They never run "Install LockHunter.bat" and never
REM  need Python.
REM
REM  Requirements to BUILD (on THIS machine only):
REM    - Windows (PyInstaller produces a Windows .exe only when run on Windows)
REM    - Python 3.9+ from python.org
REM  Run it from the folder that contains lock_hunter.py:
REM    double-click DEVELOPER ONLY - Build EXE.bat   (or run it from a terminal)
REM ===========================================================================

cd /d "%~dp0"
set "LOG=%~dp0build_exe_log.txt"
echo Lock Hunter - DEVELOPER ONLY - Build EXE.bat > "%LOG%"
echo Started: %DATE% %TIME% >> "%LOG%"

echo.
echo ============================================================
echo    Lock Hunter - building a standalone .exe
echo ============================================================
echo.
echo   NOTE: This is the DEVELOPER build script. If you just want
echo   to USE Lock Hunter, close this window and double-click
echo   LockHunter.exe instead - you do NOT need to build anything.
echo.
choice /c YN /n /m "   Are you the developer building the .exe? [Y/N] "
if errorlevel 2 exit /b 0
echo.

if not exist "lock_hunter.py" (
  echo   ERROR: lock_hunter.py is not in this folder.
  echo   Put DEVELOPER ONLY - Build EXE.bat next to lock_hunter.py and run it again.
  echo.
  echo   RESULT: lock_hunter.py missing >> "%LOG%"
  pause
  exit /b 1
)

REM --- Find Python: py launcher first, then python / python3 on PATH, then a
REM     scan of the usual python.org install folders. ---
set "PYEXE="
py -3 --version >nul 2>&1 && set "PYEXE=py -3"
if not defined PYEXE ( py --version >nul 2>&1 && set "PYEXE=py" )
if not defined PYEXE ( python --version >nul 2>&1 && set "PYEXE=python" )
if not defined PYEXE ( python3 --version >nul 2>&1 && set "PYEXE=python3" )
if not defined PYEXE call :scan_python "%LOCALAPPDATA%\Programs\Python"
if not defined PYEXE call :scan_python "%PROGRAMFILES%"
if not defined PYEXE call :scan_python "%PROGRAMFILES(x86)%"
if not defined PYEXE call :scan_python "%SystemDrive%"
if not defined PYEXE goto :no_python

echo Using Python: %PYEXE%
>>"%LOG%" echo --- python version ---
%PYEXE% --version >>"%LOG%" 2>&1

REM --- Isolated build environment so this never disturbs your system Python. ---
echo Setting up a clean build environment...
>>"%LOG%" echo --- venv ---
if exist ".venv_build" rmdir /s /q ".venv_build"
%PYEXE% -m venv ".venv_build" >>"%LOG%" 2>&1
if errorlevel 1 goto :env_failed
call ".venv_build\Scripts\activate.bat"

echo Installing build dependencies (this can take a minute)...
>>"%LOG%" echo --- pip install ---
python -m pip install --upgrade pip >>"%LOG%" 2>&1
REM requests/pillow/openpyxl are RUNTIME deps that must be bundled into the exe;
REM pyinstaller does the freezing.
pip install requests pillow openpyxl pyinstaller >>"%LOG%" 2>&1
if errorlevel 1 goto :dep_failed

echo Cleaning previous build output...
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist LockHunter.spec del /f /q LockHunter.spec

REM --- Icon: prefer a real assets\lpu_icon.ico; otherwise extract the icon
REM     that is EMBEDDED in lock_hunter.py so the .exe still gets the LPU icon
REM     with no assets folder present. Bundle assets\ too if it exists. ---
set "ICON_OPT="
set "DATA_OPT="
if exist "assets" set DATA_OPT=--add-data "assets;assets"
if exist "assets\lpu_icon.ico" (
  set ICON_OPT=--icon "assets\lpu_icon.ico"
) else (
  echo   Extracting the embedded LPU icon...
  python lock_hunter.py --extract-icon "_built_icon.ico" >>"%LOG%" 2>&1
  if exist "_built_icon.ico" (
    set ICON_OPT=--icon "_built_icon.ico"
  ) else (
    echo   NOTE: could not extract the embedded icon; using the default.
    >>"%LOG%" echo icon extract failed - using default
  )
)

echo Building LockHunter.exe (this can take a minute or two)...
>>"%LOG%" echo --- pyinstaller ---
pyinstaller --onefile --windowed --name LockHunter ^
  %ICON_OPT% ^
  %DATA_OPT% ^
  --hidden-import openpyxl ^
  --hidden-import openpyxl.cell._writer ^
  lock_hunter.py >>"%LOG%" 2>&1
set "PYI_RC=%ERRORLEVEL%"

if exist "_built_icon.ico" del /f /q "_built_icon.ico"

if not "%PYI_RC%"=="0" goto :build_failed
if not exist "dist\LockHunter.exe" goto :build_failed

echo.
echo ============================================================
echo    SUCCESS - built  dist\LockHunter.exe
echo ============================================================
echo.
echo   That single file is the whole program. It runs on any
echo   Windows PC with no Python and no install - just double-click.
echo.
echo   To release it: put  dist\LockHunter.exe  in your zip and
echo   hand that out. Users do NOT need Install LockHunter.bat.
echo.
>>"%LOG%" echo RESULT: success - dist\LockHunter.exe

REM --- Refresh the DEVELOPER Desktop shortcut so it targets THIS fresh build
REM     with the current icon. Sweeps every old Lock Hunter shortcut variant
REM     (that's how duplicates and stale icons happen), then creates ONE
REM     canonical "Lock Hunter.lnk". Same logic as Install LockHunter.bat.
for /f "usebackq delims=" %%D in (`powershell -NoProfile -Command "[Environment]::GetFolderPath('Desktop')"`) do set "DESKTOP_DIR=%%D"
if not defined DESKTOP_DIR set "DESKTOP_DIR=%USERPROFILE%\Desktop"
set "EXE_PATH=%~dp0dist\LockHunter.exe"
set "LNK_PATH=%DESKTOP_DIR%\Lock Hunter.lnk"
for %%B in ("%DESKTOP_DIR%" "%USERPROFILE%\Desktop" "%USERPROFILE%\OneDrive\Desktop" "%PUBLIC%\Desktop") do (
  del /f /q "%%~B\Lock Hunter*.lnk" >nul 2>&1
  del /f /q "%%~B\LockHunter*.lnk" >nul 2>&1
)
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
set "ICON_ARG="
if exist "%ICON_FILE%" set "ICON_ARG=$s.IconLocation='%ICON_FILE%,0';"
powershell -NoProfile -Command "$w=New-Object -ComObject WScript.Shell; $s=$w.CreateShortcut('%LNK_PATH%'); $s.TargetPath='%EXE_PATH%'; $s.WorkingDirectory='%~dp0dist'; %ICON_ARG% $s.Save()"
powershell -NoProfile -Command "ie4uinit.exe -show" >nul 2>&1
if exist "%LNK_PATH%" echo   Desktop shortcut refreshed - new icon, points at this build.

REM open the dist folder so the exe is right there
start "" "%~dp0dist"
pause
exit /b 0


REM ------------------------------------------------------------------ helpers
:scan_python
REM %1 = folder to search for python.exe (one level deep, newest wins)
if defined PYEXE goto :eof
if not exist "%~1" goto :eof
for /f "delims=" %%D in ('dir /b /ad /o-n "%~1\Python*" 2^>nul') do (
  if exist "%~1\%%D\python.exe" (
    set "PYEXE=%~1\%%D\python.exe"
    goto :eof
  )
)
if exist "%~1\python.exe" set "PYEXE=%~1\python.exe"
goto :eof


REM ------------------------------------------------------------------ failures
:no_python
echo.
echo ============================================================
echo    PYTHON IS NOT INSTALLED ON THIS (BUILD) COMPUTER
echo ============================================================
echo.
echo   DEVELOPER ONLY - Build EXE.bat needs Python 3 to FREEZE the .exe. This is a
echo   one-time requirement on YOUR build machine only - the .exe
echo   it produces needs no Python at all.
echo.
echo   Install Python 3 from  https://www.python.org/downloads/
echo   (tick "Add python.exe to PATH" on the first screen), open a
echo   NEW window, and run DEVELOPER ONLY - Build EXE.bat again.
echo.
>>"%LOG%" echo RESULT: Python not found
choice /c YN /n /m "    Open the Python download page now? [Y/N] "
if not errorlevel 2 start "" "https://www.python.org/downloads/"
echo.
pause
exit /b 1

:env_failed
echo.
echo   ERROR: could not create the build virtual environment.
echo   The log has been opened - it usually shows why.
>>"%LOG%" echo RESULT: venv creation failed
start "" "%LOG%"
pause
exit /b 1

:dep_failed
echo.
echo   ERROR: could not install the build dependencies (pip).
echo   The log has been opened - check your internet connection.
>>"%LOG%" echo RESULT: dependency install failed
start "" "%LOG%"
pause
exit /b 1

:build_failed
echo.
echo   ERROR: PyInstaller did not produce dist\LockHunter.exe.
echo   The log has been opened - please review or send it over.
>>"%LOG%" echo RESULT: pyinstaller build failed (rc=%PYI_RC%)
start "" "%LOG%"
pause
exit /b 1
