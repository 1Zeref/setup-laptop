Write-Host "=============================="
Write-Host "Thông tin máy tính"
Write-Host "=============================="
# Lấy thông tin BIOS để lấy Serial Number
$bios = Get-WmiObject -Class Win32_BIOS

# Hiển thị Serial Number
Write-Host "Serial Number: $($bios.SerialNumber)"

# Dừng lại, yêu cầu người dùng nhấn Enter để thoát
Read-Host -Prompt "Nhấn Enter để thoát"
