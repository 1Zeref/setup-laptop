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
echo Available scripts:
echo 1. !NAMES[1]!
echo 2. !NAMES[2]!
echo 3. Exit
echo.

:: Get user selection
set /p choice="Select a script to run (1-3): "

:: Validate input choice and process selection
if "!choice!"=="1" goto :RUNSCRIPT
if "!choice!"=="2" goto :RUNSCRIPT
if "!choice!"=="3" (
    echo Exiting...
    timeout /t 1 /nobreak > nul
    exit /b
)

echo Invalid choice! Please select a valid option.
timeout /t 2 /nobreak > nul
goto :MENU

:RUNSCRIPT
if "!SCRIPTS[%choice%]!"=="" (
    echo Error: Script definition not found for choice %choice%.
    timeout /t 2 /nobreak > nul
    goto :MENU
)

:: Select the script file
set "SCRIPT=!SCRIPTS[%choice%]!"
set "SCRIPTNAME=!NAMES[%choice%]!"

echo Running "!SCRIPTNAME!"...
:: Run the selected PowerShell script with admin privileges
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "irm '!SCRIPT!' | iex"

echo.
echo Script "!SCRIPTNAME!" finished.
echo What would you like to do next?
echo 1. Run another script
echo 2. Exit
set /p next_action="Select an option (1-2): "

if "!next_action!"=="1" goto :MENU
if "!next_action!"=="2" (
    echo Exiting...
    timeout /t 1 /nobreak > nul
    exit /b
)

echo Invalid option. Returning to menu.
timeout /t 2 /nobreak > nul
goto :MENU

endlocal