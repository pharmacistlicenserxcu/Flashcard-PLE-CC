@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo.
echo ================================================================
echo   PharmaCU PLE-CC Flashcard - Auto Deploy (Compile + Push)
echo   Target: pharmacistlicenserxcu/Flashcard-PLE-CC
echo ================================================================
echo.

REM --- STEP 0: Set Git Remote to SSH ---
git remote set-url origin git@github.com:pharmacistlicenserxcu/Flashcard-PLE-CC.git

REM --- STEP 1: Compile offline database ---
echo [1/2] Compiling offline database from Google Sheets...
echo.
python compile_offline_db.py
if errorlevel 1 (
    echo.
    echo [ERROR] Compilation failed! Push aborted.
    echo Please fix the error above and try again.
    echo.
    pause
    exit /b 1
)
echo [OK] Compilation finished successfully.
echo.

REM --- STEP 2: Git add, commit, push ---
echo [2/2] Pushing to GitHub via SSH...
echo.

git status -s > tmp_status.txt 2>nul
set size=0
for %%A in (tmp_status.txt) do set size=%%~zA
del tmp_status.txt 2>nul

if "%size%"=="0" (
    echo [OK] No new file changes to commit. Checking unpushed commits...
    git push origin main
    goto FINISH
)

echo [INFO] Changed files:
git status --short
echo.

set MYDATE=%date:~0,10%
set MYTIME=%time:~0,5%
set COMMIT_MSG=update: sync flashcards %MYDATE% %MYTIME%

echo [INFO] Commit: %COMMIT_MSG%
echo.
git add -A
git commit -m "%COMMIT_MSG%"
git push origin main

:FINISH
echo.
if errorlevel 1 (
    echo [ERROR] Push failed. Check internet or git permissions.
) else (
    echo [SUCCESS] Deploy complete! Live on GitHub Pages.
)
echo.
pause
