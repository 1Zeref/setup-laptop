Write-Host "=============================="
Write-Host "Thông tin máy tính"
Write-Host "=============================="
Write-Host "Tên máy tính: $env:COMPUTERNAME"
# Lấy thông tin BIOS để lấy Serial Number
$bios = Get-WmiObject -Class Win32_BIOS
Write-Host "Serial Number: $($bios.SerialNumber)"

$ReportPath = "$env:USERPROFILE\battery-report.html"
Write-Host "$ReportPath"
powercfg /batteryreport /output $ReportPath
if (Test-Path $ReportPath) {
    Start-Process $ReportPath
} else {
    Write-Error "Không tìm thấy báo cáo pin tại: $ReportPath"
}

# Dừng lại, yêu cầu người dùng nhấn Enter để thoát
Read-Host -Prompt "Nhấn Enter để thoát"
