@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo.
echo ============================================================
echo   💊 PharmaCU Flashcard PLE CC — Auto Compile ^& Push
echo   Account: pharmacistlicenserxcu
echo   Repo   : https://github.com/pharmacistlicenserxcu/Flashcard-PLE-CC
echo ============================================================
echo.

:: ─── STEP 0: Lock Git Remote & User to pharmacistlicenserxcu ──
git config user.name "pharmacistlicenserxcu"
git remote set-url origin https://pharmacistlicenserxcu@github.com/pharmacistlicenserxcu/Flashcard-PLE-CC.git

:: ─── STEP 1: Compile Offline Database ──────────────────────────
echo [1/2] 📦 Compiling offline database from Google Sheets...
python compile_offline_db.py
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Compilation had an issue, continuing with existing files...
) else (
    echo [OK] Compile finished successfully.
)
echo.

:: ─── STEP 2: Git Commit & Push ────────────────────────────────
echo [2/2] 🐙 Checking Git status and pushing to GitHub...
git add -A

git diff --cached --quiet
if %ERRORLEVEL% NEQ 0 (
    set MYDATE=%date:~0,10%
    set MYTIME=%time:~0,5%
    echo [INFO] Committing changes...
    git commit -m "update: sync flashcards %MYDATE% %MYTIME%"
) else (
    echo [INFO] No new file modifications to commit.
)

echo [INFO] Pushing to GitHub (origin main) as pharmacistlicenserxcu...
git push origin main
if %ERRORLEVEL%==0 (
    echo [SUCCESS] GitHub push complete! Live on GitHub Pages.
) else (
    echo [WARNING] GitHub push encountered an issue.
)

echo.
echo ============================================================
echo   🎉 ALL DONE! เรียบร้อยทุกขั้นตอน
echo ============================================================
echo.
pause
