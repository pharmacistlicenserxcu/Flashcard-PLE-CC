@echo off
chcp 65001 >nul
title PharmaCU Flashcard -- Offline Database Compiler
cls

cd /d "%~dp0"

if not "%~1"=="" (
    python "compile_offline_db.py" %*
    goto :done
)

echo ==============================================================
echo   🚀 PharmaCU Flashcard Database Compiler (Local)
echo ==============================================================
echo   [1] Compile ทั้งหมด (Full Compile + สกัด In-cell Images)
echo   [2] Compile ทั้งหมดแบบเร็ว (Fast Mode / Skip Images)
echo   [3] Compile เฉพาะ Track Clinic (16 ชีต)
echo   [4] Compile เฉพาะ Track Product (12 ชีต)
echo   [5] Compile เฉพาะเรื่อง (พิมพ์ชื่อชีตหรือคำค้นหา)
echo ==============================================================
set /p choice="เลือกโหมด (1-5) [ค่าเริ่มต้น 1]: "

if "%choice%"=="" set choice=1
if "%choice%"=="1" (
    echo.
    echo ⚙️ กำลังรัน Full Compile (พร้อมรูปภาพ)...
    python "compile_offline_db.py" --mode all
    goto :done
)
if "%choice%"=="2" (
    echo.
    echo ⚙️ กำลังรัน Fast Compile (ข้ามรูปภาพ)...
    python "compile_offline_db.py" --mode all --skip-images
    goto :done
)
if "%choice%"=="3" (
    echo.
    echo ⚙️ กำลังรัน Track: Clinic...
    python "compile_offline_db.py" --mode track --query "Clinic" --skip-images
    goto :done
)
if "%choice%"=="4" (
    echo.
    echo ⚙️ กำลังรัน Track: Product...
    python "compile_offline_db.py" --mode track --query "Product" --skip-images
    goto :done
)
if "%choice%"=="5" (
    echo.
    set /p qtext="พิมพ์ชื่อชีตหรือคำค้นหา (เช่น Musculo, Cardio, Titrations): "
    if "%qtext%"=="" (
        echo ⚠️ ไม่ได้ระบุคำค้นหา ยกเลิกการทำงาน
        pause
        exit /b 0
    )
    python "compile_offline_db.py" --mode keyword --query "%qtext%" --skip-images
    goto :done
)

python "compile_offline_db.py"

:done
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ==========================================
    echo  ❌ ERROR: Compile failed!
    echo ==========================================
    pause
    exit /b 1
)

echo.
echo ==============================================================
echo  ✅ SUCCESS! ฐานข้อมูลออฟไลน์อัปเดตเรียบร้อยแล้ว
echo ==============================================================
echo.
pause
