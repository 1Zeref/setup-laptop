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

:: Định nghĩa danh sách các script PowerShell và tên hiển thị tương ứng
set "SCRIPTS[1]=https://raw.githubusercontent.com/1Zeref/setup-laptop/main/functions/get-informations.ps1"
set "NAMES[1]=Get System Information"
set "SCRIPTS[2]=https://raw.githubusercontent.com/1Zeref/setup-laptop/main/functions/config.ps1"
set "NAMES[2]=Configure Windows"
set "SCRIPTS[3]=https://christitus.com/win"
set "NAMES[3]=Chris Titus Tech's Windows Utility"
set "SCRIPTS[4]=https://get.activated.win"
set "NAMES[4]=Microsoft-Activation-Scripts"

:MENU
cls
echo =====================================
echo      SCRIPT SELECTION MENU
echo =====================================
echo.
echo Available scripts:
echo 1. !NAMES[1]!
echo 2. !NAMES[2]!
echo 3. !NAMES[3]!
echo 4. !NAMES[4]!
echo 5. Exit
echo.
echo (Press ENTER without typing to exit)
echo -------------------------------------

:: Nhận lựa chọn của người dùng
set "choice="
set /p choice="Select a script to run (1-5) or leave blank to Exit: "

:: Kiểm tra nếu nhập rỗng (chỉ nhấn Enter)
if "!choice!"=="" (
    echo No selection made. Exiting script...
    exit /b
)

:: Xử lý lựa chọn của người dùng
if "!choice!"=="1" goto :RUNSCRIPT_1
if "!choice!"=="2" goto :RUNSCRIPT_2
if "!choice!"=="3" goto :RUNSCRIPT_3
if "!choice!"=="4" goto :RUNSCRIPT_4
if "!choice!"=="5" (
    echo Exiting script as per selection...
    exit /b
)

echo Invalid choice: "!choice!". Please select a valid option.
goto :MENU

:RUNSCRIPT_1
set "SCRIPT_URL=!SCRIPTS[1]!"
set "SCRIPT_NAME=!NAMES[1]!"
goto :EXECUTESCRIPT

:RUNSCRIPT_2
set "SCRIPT_URL=!SCRIPTS[2]!"
set "SCRIPT_NAME=!NAMES[2]!"
goto :EXECUTESCRIPT

:RUNSCRIPT_3
set "SCRIPT_URL=!SCRIPTS[3]!"
set "SCRIPT_NAME=!NAMES[3]!"
goto :EXECUTESCRIPT

:RUNSCRIPT_4
set "SCRIPT_URL=!SCRIPTS[4]!"
set "SCRIPT_NAME=!NAMES[4]!"
goto :EXECUTESCRIPT

:EXECUTESCRIPT
cls
if "!SCRIPT_URL!"=="" (
    echo Error: Script definition not found.
    goto :MENU
)

echo.
echo =====================================
echo Running: !SCRIPT_NAME!
echo From URL: !SCRIPT_URL!
echo =====================================
echo.

:: Thực thi script PowerShell với quyền admin
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm '!SCRIPT_URL!' | iex"

echo.
echo =====================================
echo Script "!SCRIPT_NAME!" finished.
goto :MENU

endlocal
