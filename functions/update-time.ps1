# Kiểm tra và yêu cầu quyền Administrator nếu chưa có
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Yêu cầu chạy dưới quyền Administrator. Đang khởi động lại với quyền Admin..."
    Start-Process powershell -Verb runAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# Đặt múi giờ về UTC+7 (Bangkok, Hanoi, Jakarta)
tzutil /s "SE Asia Standard Time"
Write-Host "[+] Đã đặt múi giờ về UTC+7 (Bangkok, Hanoi, Jakarta)"

# Cập nhật thời gian từ máy chủ Internet
Write-Host "[+] Đang đồng bộ thời gian với máy chủ thời gian..."
w32tm /resync | Out-Null

# Đặt định dạng ngày ngắn (Short Date) thành dd/MM/yyyy
Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "sShortDate" -Value "dd/MM/yyyy"
Write-Host "Đã cập nhật định dạng ngày ngắn (Short Date) thành dd/MM/yyyy"