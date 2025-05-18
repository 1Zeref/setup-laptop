# Kiểm tra và yêu cầu quyền Administrator nếu chưa có
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Yêu cầu chạy dưới quyền Administrator. Đang khởi động lại với quyền Admin..."
    Start-Process powershell -Verb runAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

try {
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

    # Không hiện thông báo UAC cho tài khoản quản trị viên
    Set-ItemProperty -Path $regPath -Name "ConsentPromptBehaviorAdmin" -Value 0 -Force

    # Tắt chế độ Secure Desktop cho UAC
    Set-ItemProperty -Path $regPath -Name "PromptOnSecureDesktop" -Value 0 -Force

    Write-Host "UAC đã được chuyển sang 'Never notify'. Bạn vui lòng khởi động lại máy để thay đổi có hiệu lực." -ForegroundColor Green
}
catch {
    Write-Error "Có lỗi xảy ra khi thực hiện thay đổi UAC: $_"
}
