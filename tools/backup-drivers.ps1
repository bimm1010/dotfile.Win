<#
.SYNOPSIS
    Sao lưu (Export) toàn bộ Driver bên thứ 3 của laptop vào thư mục chỉ định.
.EXAMPLE
    .\backup-drivers.ps1 -Destination "D:\LaptopDriversBackup"
#>
param(
    [string]$Destination = "$HOME\DriversBackup"
)

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Vui lòng chạy script này với quyền Administrator để trích xuất đầy đủ Driver!"
    exit 1
}

if (-not (Test-Path $Destination)) {
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
}

Write-Host "Đang trích xuất toàn bộ Driver phần cứng của laptop vào: $Destination..." -ForegroundColor Cyan
Export-WindowsDriver -Online -Destination $Destination

Write-Host "Hoàn tất sao lưu! Hãy lưu thư mục này vào ổ D: hoặc USB để dùng khi cài lại Win." -ForegroundColor Green
