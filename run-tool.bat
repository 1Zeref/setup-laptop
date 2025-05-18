@echo off
title Chạy Script PS1 từ URL
color 0A

:: Menu chọn
echo ===========================
echo Chon script ban muon chay:
echo 1. Lấy Serial
echo ===========================
set /p choice="Nhap lua chon (1-1): "

:: Gán URL tương ứng
if "%choice%"=="1" set "ps1url=https://raw.githubusercontent.com/1Zeref/setup-laptop/main/get-informations.ps1"

:: Kiểm tra quyền Admin
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Dang yeu cau quyen Administrator...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Tải và chạy script từ URL bằng PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm '%ps1url%' | iex"

:: Dừng để xem kết quả
pause
