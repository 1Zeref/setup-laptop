# Kiểm tra và yêu cầu quyền Administrator nếu chưa có
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Yêu cầu chạy dưới quyền Administrator. Đang khởi động lại với quyền Admin..."
    Start-Process powershell -Verb runAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# Đặt múi giờ về UTC+7 (Bangkok, Hanoi, Jakarta)
tzutil /s "SE Asia Standard Time"
Write-Host "[✓] Đã đặt múi giờ về UTC+7 (Bangkok, Hanoi, Jakarta)"

# Cập nhật thời gian từ máy chủ Internet
Write-Host "[✓] Đang đồng bộ thời gian với máy chủ thời gian..."
w32tm /resync | Out-Null

# Hiển thị ngày hiện tại theo định dạng dd/MM/yyyy
$now = Get-Date
Write-Host "`nNgày hiện tại: $($now.ToString('dd/MM/yyyy'))"

# Kết thúc
Read-Host "`nNhấn Enter để thoát"