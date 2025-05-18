function Log($Message) {
    Write-Output $Message
}

try {
    $iconRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
    $desktopRegPath = "HKCU:\Software\Microsoft\Windows\Shell\Bags\1\Desktop"
    
    if (-not (Test-Path $iconRegPath)) {
        New-Item -Path $iconRegPath -Force | Out-Null
    }
    
    Set-ItemProperty -Path $iconRegPath -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0
    Set-ItemProperty -Path $iconRegPath -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Value 0
    Set-ItemProperty -Path $iconRegPath -Name "{26EE0668-A00A-44D7-9371-BEB064C98683}" -Value 0
    Set-ItemProperty -Path $iconRegPath -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Value 0
	Set-ItemProperty -Path $iconRegPath -Name "{59031A47-3F72-44A7-89C5-5595FE6B30EE}" -Value 0
    if (-not (Test-Path $desktopRegPath)) {
        New-Item -Path $desktopRegPath -Force | Out-Null
    }
    
    $fflags = Get-ItemProperty -Path $desktopRegPath -Name FFlags -ErrorAction SilentlyContinue
    $newFFlags = if ($fflags) { $fflags.FFlags -bor 0x1 } else { 0x1 }
    Set-ItemProperty -Path $desktopRegPath -Name FFlags -Value $newFFlags
}
catch {
    Log "Failed to modify desktop settings: $($_.Exception.Message)"
}

Log "Desktop Icons Configuration Completed."