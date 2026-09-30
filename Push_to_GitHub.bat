@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo.
echo ============================================================
echo   💊 PharmaCU Flashcard PLE CC — Auto Compile ^& Push
echo   Account: pharmacistlicenserxcu
echo   Repo   : https://github.com/pharmacistlicenserxcu/Flashcard-PLE-CC
echo   Clasp  : 1PVTA5AtBD5foNOTJaQm1OpxXZx2geDp5ZiQM0A3Jz4F-0btUSby-p0Hd
echo ============================================================
echo.

:: ─── STEP 0: Lock Git Remote & User to pharmacistlicenserxcu ──
:: ล็อค account ให้ตรงกับ Windows Credential Manager เพื่อไม่ให้เด้งถามเลือก Email
git config user.name "pharmacistlicenserxcu"
git remote set-url origin https://pharmacistlicenserxcu@github.com/pharmacistlicenserxcu/Flashcard-PLE-CC.git

:: ─── STEP 1: Compile Offline Database ──────────────────────────
echo [1/3] 📦 Compiling offline database from Google Sheets...
python compile_offline_db.py
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Compilation had an issue, continuing with existing files...
) else (
    echo [OK] Compile finished successfully.
)
echo.

:: ─── STEP 2: Git Commit & Push ────────────────────────────────
echo [2/3] 🐙 Checking Git status and pushing to GitHub...
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

:: ─── STEP 3: Clasp Push to Google Apps Script ─────────────────
echo [3/3] ⚡ Pushing to Google Apps Script (Clasp)...
if exist "google_apps_script\.clasp.json" (
    pushd "google_apps_script"
    call clasp push --force
    if %ERRORLEVEL%==0 (
        echo [SUCCESS] Clasp push complete!
    ) else (
        echo [WARNING] Clasp push encountered an issue.
    )
    popd
) else (
    echo [SKIP] google_apps_script\.clasp.json not found.
)

echo.
echo ============================================================
echo   🎉 ALL DONE! เรียบร้อยทุกขั้นตอน ไม่ต้องเลือก Email อีกแล้ว
echo ============================================================
echo.
pause
