@echo off

::----------------------------------------------------------------------
:: Phần kiểm tra và yêu cầu quyền Administrator
::----------------------------------------------------------------------
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
::----------------------------------------------------------------------

setlocal EnableDelayedExpansion

:: List of PowerShell scripts with customized display names
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
echo 1. !NAMES[1]!
echo 2. !NAMES[2]!
echo 3. Exit
echo.
echo (Press ENTER without typing to exit)
echo -------------------------------------

:: Get user selection
set "choice=" :: Đảm bảo biến choice rỗng trước khi nhận input mới
set /p choice="Select a script to run (1-3), or leave blank to Exit: "

:: Kiểm tra nếu người dùng không nhập gì (chỉ nhấn Enter)
if "!choice!"=="" (
    echo No selection made. Exiting script...
    timeout /t 1 /nobreak > nul
    exit /b
)

:: Validate input choice and process selection
if "!choice!"=="1" goto :RUNSCRIPT_1
if "!choice!"=="2" goto :RUNSCRIPT_2
if "!choice!"=="3" (
    echo Exiting script as per selection...
    timeout /t 1 /nobreak > nul
    exit /b
)

echo Invalid choice: "!choice!". Please select a valid option.
echo Returning to menu in 2 seconds...
timeout /t 2 /nobreak > nul
goto :MENU

:RUNSCRIPT_1
set "SCRIPT_URL=!SCRIPTS[1]!"
set "SCRIPT_NAME=!NAMES[1]!"
goto :EXECUTESCRIPT

:RUNSCRIPT_2
set "SCRIPT_URL=!SCRIPTS[2]!"
set "SCRIPT_NAME=!NAMES[2]!"
goto :EXECUTESCRIPT

:EXECUTESCRIPT
if "!SCRIPT_URL!"=="" (
    echo Error: Script definition not found.
    echo Returning to menu in 2 seconds...
    timeout /t 2 /nobreak > nul
    goto :MENU
)

echo.
echo =====================================
echo Running: !SCRIPT_NAME!
echo From URL: !SCRIPT_URL!
echo =====================================
echo.

:: Run the selected PowerShell script with admin privileges
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "irm '!SCRIPT_URL!' | iex"

echo.
echo =====================================
echo Script "!SCRIPT_NAME!" finished.
echo Returning to menu in 2 seconds...
echo =====================================
timeout /t 2 /nobreak > nul
goto :MENU

endlocal