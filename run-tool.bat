@echo off

::----------------------------------------------------------------------
:: Kiểm tra và yêu cầu quyền Administrator
::----------------------------------------------------------------------
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
::----------------------------------------------------------------------

setlocal EnableDelayedExpansion

:: Các script PowerShell cùng tên hiển thị
set "SCRIPTS[1]=https://raw.githubusercontent.com/1Zeref/setup-laptop/main/functions/get-informations.ps1"
set "NAMES[1]=Get System Information"
set "SCRIPTS[2]=https://raw.githubusercontent.com/1Zeref/setup-laptop/main/functions/config.ps1"
set "NAMES[2]=Configure Windows"

:MENU
cls
echo =====================================
echo      SCRIPT SELECTION MENU
echo =====================================
echo.
echo Available scripts:
if not "!NAMES[1]!"=="" echo 1. !NAMES[1]!
if not "!NAMES[2]!"=="" echo 2. !NAMES[2]!
echo 3. Exit
echo.
echo (Press ENTER without typing to exit)
echo -------------------------------------

:: Nhận lựa chọn của người dùng
set "choice="
set /p choice="Select a script to run (1-3), or leave blank to Exit: "

:: Kiểm tra nếu nhập rỗng
if "!choice!"=="" (
    echo No selection made. Exiting script...
    timeout /t 1 /nobreak >nul
    exit /b
)

:: Kiểm tra lựa chọn hợp lệ và nó có tồn tại trong menu hay không
if "!choice!"=="1" (
    if "!NAMES[1]!"=="" (
        echo Invalid selection! Option 1 is no longer available.
        timeout /t 2 /nobreak >nul
        goto :MENU
    ) else (
        goto :RUNSCRIPT_1
    )
)
if "!choice!"=="2" (
    if "!NAMES[2]!"=="" (
        echo Invalid selection! Option 2 is no longer available.
        timeout /t 2 /nobreak >nul
        goto :MENU
    ) else (
        goto :RUNSCRIPT_2
    )
)
if "!choice!"=="3" (
    echo Exiting script as per selection...
    timeout /t 1 /nobreak >nul
    exit /b
)

echo Invalid choice: "!choice!". Please select a valid option.
echo Returning to menu in 2 seconds...
timeout /t 2 /nobreak >nul
goto :MENU
::----------------------------------------------------------------------
:EXECUTESCRIPT
cls
if "!SCRIPT_URL!"=="" (
    echo Error: Script definition not found.
    echo Returning to menu in 2 seconds...
    timeout /t 2 /nobreak >nul
    goto :MENU
)

echo.
echo =====================================
echo Running: !SCRIPT_NAME!
echo From URL: !SCRIPT_URL!
echo =====================================
echo.

:: Chạy script PowerShell với quyền admin
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm '!SCRIPT_URL!' | iex"

echo.
echo =====================================
echo Script "!SCRIPT_NAME!" finished.
echo Returning to menu in 2 seconds...
echo =====================================
timeout /t 2 /nobreak >nul
goto :MENU

endlocal
