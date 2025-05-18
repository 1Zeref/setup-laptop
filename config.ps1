# Kiểm tra quyền admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Yêu cầu quyền Administrator. Đang khởi động lại..."
    Start-Process powershell -Verb runAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

# Danh sách các link raw GitHub chứa các script .ps1
$ps1Links = @(
    "https://raw.githubusercontent.com/1Zeref/setup-laptop/main/functions/update-time.ps1"
    "https://raw.githubusercontent.com/1Zeref/setup-laptop/main/functions/power-and-sleep.ps1"
    "https://raw.githubusercontent.com/1Zeref/setup-laptop/main/functions/desktop.ps1"
    # <-- Thêm link khác tại đây nếu có
)

# Chạy từng link
foreach ($link in $ps1Links) {
    Write-Host "`n[→] Đang chạy script: $link" -ForegroundColor Cyan
    try {
        Invoke-RestMethod -Uri $link | Invoke-Expression
    }
    catch {
        Write-Host "[!] Lỗi khi chạy script từ $link" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}
# Khởi động lại Explorer
Stop-Process -Name explorer -Force; Start-Sleep 2; Start-Process explorer

Write-Host "`n[✓] Đã chạy xong tất cả các script." -ForegroundColor Green
Read-Host "`nNhấn Enter để thoát"