# Kiểm tra và yêu cầu quyền Administrator nếu chưa có
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Yêu cầu chạy dưới quyền Administrator. Đang khởi động lại với quyền Admin..."
    Start-Process powershell -Verb runAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

#"Screen: When plugged in, turn off after" (Màn hình: Khi cắm điện, tắt sau) thành "Never"
powercfg -change -monitor-timeout-ac 0

#"Sleep: When plugged in, PC goes to sleep after" (Ngủ: Khi cắm điện, PC chuyển sang chế độ ngủ sau) thành "Never"
powercfg -change -standby-timeout-ac 0

#"Sleep: On battery power, PC goes to sleep after" (Ngủ: Khi dùng pin, PC chuyển sang chế độ ngủ sau) thành "Never" (tùy chọn, nếu bạn muốn áp dụng cho cả khi dùng pin)
powercfg -change -standby-timeout-dc 0

#Vô hiệu hóa "Turn on fast startup" 
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled -Value 0 -Type DWord -Force
#Vô hiệu hóa "Sleep trên Power Menu"
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings"
$Name = "ShowSleepOption"
$Value = 0 # Giá trị để ẩn Sleep (0 = ẩn, 1 = hiện)
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force -ErrorAction SilentlyContinue
}
Set-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -Type DWord -Force -ErrorAction Stop

#Kích hoạt chế độ "High Performance" (Chế độ hiệu suất tối ưu)
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c