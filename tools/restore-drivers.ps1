<#
.SYNOPSIS
    Khôi phục (Install) toàn bộ Driver đã sao lưu cho laptop (hoạt động offline 100%).
.EXAMPLE
    .\restore-drivers.ps1 -Source "D:\LaptopDriversBackup"
#>
param(
    [string]$Source = "$HOME\DriversBackup"
)

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Vui lòng chạy script này với quyền Administrator để cài đặt Driver!"
    exit 1
}

if (-not (Test-Path $Source)) {
    Write-Error "Không tìm thấy thư mục Driver sao lưu tại: $Source"
    exit 1
}

Write-Host "Đang khôi phục toàn bộ Driver phần cứng từ: $Source..." -ForegroundColor Cyan
pnputil.exe /add-driver "$Source\*.inf" /subdirs /install

Write-Host "Đã nạp toàn bộ Driver thành công! Khởi động lại máy để áp dụng hoàn toàn." -ForegroundColor Green
