# Kiểm tra quyền admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Yêu cầu quyền Administrator. Đang khởi động lại..."
    Start-Process powershell -Verb runAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}
# Fix lỗi chia sẻ máy in
Set-SmbClientConfiguration -RequireSecuritySignature $false
$networkAddress = Read-Host "Input Internet or Network address"
cmdkey /add:$networkAddress /user:Guest /pass:""
#Sửa lỗi 0x0000011b
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Print" -Name "RpcAuthnLevelPrivacyEnabled" -Value 0 -PropertyType DWord -Force
# Khởi động lại dịch vụ Print Spooler
Restart-Service -Name "Spooler" -Force
# Khởi động lại máy tính
$restart = Read-Host "Do you want to restart your computer? (Y/N)"
if ($restart -eq "Y" -or $restart -eq "y") {
    Restart-Computer -Force
} else {
    Write-Host "Chương trình đã hoàn tất. Không cần khởi động lại máy tính."
}
