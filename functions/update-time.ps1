# Kiểm tra và yêu cầu quyền Administrator nếu chưa có
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Yêu cầu chạy dưới quyền Administrator. Đang khởi động lại với quyền Admin..."
    Start-Process powershell -Verb runAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# Đặt múi giờ về UTC+7 (Bangkok, Hanoi, Jakarta)
tzutil /s "SE Asia Standard Time"

# Cập nhật thời gian từ máy chủ Internet
w32tm /resync | Out-Null

# Đặt định dạng ngày ngắn (Short Date) thành dd/MM/yyyy
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sShortDate" -Value "dd/MM/yyyy"

# Khởi động lại dịch vụ thời gian Windows
net stop w32time
w32tm /unregister
w32tm /register
net start w32time

# Đặt máy chủ thời gian chuẩn (ví dụ time.windows.com)
w32tm /config /manualpeerlist:"time.windows.com" /syncfromflags:manual /reliable:yes /update

# Thực hiện đồng bộ
w32tm /resync

# Đặt Region thành Việt Nam
Set-WinSystemLocale vi-VN