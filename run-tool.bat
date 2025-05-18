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

:: List of 3 PowerShell scripts with customized display names
set "SCRIPTS[1]=https://raw.githubusercontent.com/1Zeref/setup-laptop/main/get-informations.ps1"
set "NAMES[1]=Get System Information"
set "SCRIPTS[2]=https://raw.githubusercontent.com/1Zeref/setup-laptop/main/config.ps1"
set "NAMES[2]=Configure Windows"
:: Display menu with custom names
echo Available scripts:
echo 1. !NAMES[1]!
echo 2. !NAMES[2]!
:: Get user selection
set /p choice="Select a script to run (1-2): "

:: Validate input choice
if "!SCRIPTS[%choice%]!"=="" (
    echo Invalid choice! Exiting...
    timeout /t 2 /nobreak > nul
    exit /b
)

:: Select the script file
set "SCRIPT=!SCRIPTS[%choice%]!"

:: Run the selected PowerShell script with admin privileges
:: Đoạn mã gốc của bạn đã chạy PowerShell với quyền admin thông qua việc tải và thực thi,
:: nhưng việc đảm bảo bản thân batch script chạy với quyền admin từ đầu là một lớp bảo vệ tốt hơn.
:: Lệnh PowerShell bên dưới để thực thi script vẫn giữ nguyên vì nó hiệu quả.
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "irm '!SCRIPT!' | iex"

:: Automatically close the batch file after execution
exit