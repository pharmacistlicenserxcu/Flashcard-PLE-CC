@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo.
echo ============================================================
echo   ⚡ PharmaCU Flashcard PLE CC — Push to Google Apps Script
echo   Script ID: 1PVTA5AtBD5foNOTJaQm1OpxXZx2geDp5ZiQM0A3Jz4F-0btUSby-p0Hd
echo ============================================================
echo.

if exist "google_apps_script\.clasp.json" (
    echo [INFO] Pushing Code.gs to Apps Script via Clasp...
    pushd "google_apps_script"
    call clasp push --force
    if %ERRORLEVEL%==0 (
        echo.
        echo [SUCCESS] Clasp push complete! Google Apps Script updated.
    ) else (
        echo.
        echo [WARNING] Clasp push encountered an issue.
    )
    popd
) else (
    echo [ERROR] google_apps_script\.clasp.json not found!
)

echo.
pause
