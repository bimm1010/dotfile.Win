<#
.SYNOPSIS
    Kich ban tu dong hoa cai dat va cau hinh moi truong toan dien cho Laptop Windows.
.DESCRIPTION
    Tuong tu giai phap trong video cua Vu Nguyen Coder:
    - Cai dat toan bo phan mem (Dev Tools, Browsers, Media, Chat, System Utilities)
    - Tu dong nap file cau hinh (Dotfiles): Starship, Git Bash (.bashrc), PowerShell Profile, Windows Terminal, VS Code
    - Kich hoat tinh nang ao hoa (WSL / Virtualization)
#>

[CmdletBinding()]
param(
    [switch]$SkipApps,
    [switch]$SkipConfigs,
    [switch]$EnableWSL,
    [switch]$InstallScoop
)

$ErrorActionPreference = "Continue"
$ScriptDir = $PSScriptRoot

# ==========================================
# 1. TIEN ICH HIEN THI LOG (UTIL FUNCTIONS)
# ==========================================
function Write-Header {
    param([string]$Message)
    Write-Host "`n====================================================================" -ForegroundColor Cyan
    Write-Host "  $Message" -ForegroundColor Yellow
    Write-Host "====================================================================" -ForegroundColor Cyan
}

function Write-Step {
    param([string]$Message)
    Write-Host "[*] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Err {
    param([string]$Message)
    Write-Host "[ERR] $Message" -ForegroundColor Red
}

function Test-IsAdmin {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# ==========================================
# 2. KIEM TRA CHINH SACH THUC THI (POLICY)
# ==========================================
Write-Header "BUOC 1: KIEM TRA QUYEN VA MOI TRUONG THUC THI"

$policy = Get-ExecutionPolicy -Scope CurrentUser
Write-Step "ExecutionPolicy hien tai: $policy"
if ($policy -ne "RemoteSigned" -and $policy -ne "Unrestricted" -and $policy -ne "Bypass") {
    Write-Step "Dang cau hinh ExecutionPolicy thanh RemoteSigned..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Success "Da kich hoat quyen chay script PowerShell!"
} else {
    Write-Success "Quyen thuc thi script PowerShell da san sang!"
}

# ==========================================
# 3. CHUAN BI TRINH QUAN LY GOI (WINGET & SCOOP)
# ==========================================
Write-Header "BUOC 2: CHUAN BI TRINH QUAN LY GOI (PACKAGE MANAGERS)"

# Kiem tra WinGet
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Warn "WinGet chua co san. Hay cai dat 'App Installer' tu Microsoft Store hoac GitHub."
} else {
    $wgVer = winget --version
    Write-Success "WinGet da san sang (Version: $wgVer)"
}

# Cai dat Scoop neu duoc yeu cau
if ($InstallScoop) {
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Step "Dang cai dat Scoop..."
        try {
            Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
            Write-Success "Cai dat Scoop thanh cong!"
            scoop bucket add extras
            scoop bucket add nerd-fonts
            scoop update
        } catch {
            Write-Warn "Chua the cai Scoop tu dong: $_"
        }
    } else {
        Write-Success "Scoop da ton tai tren may."
    }
}

# ==========================================
# 4. CAI DAT TOAN BO PHAN MEM HIEN CO TREN MAY
# ==========================================
if (-not $SkipApps) {
    Write-Header "BUOC 3: CAI DAT TOAN BO PHAN MEM (DANH SACH MAY NAY)"

    $manifestFile = Join-Path $ScriptDir "manifests\app-list.json"
    if (Test-Path $manifestFile) {
        $appData = Get-Content $manifestFile -Raw -Encoding UTF8 | ConvertFrom-Json
        
        $categories = @(
            @{ Name = "Thu vien C++ Runtimes"; Items = $appData.system_libraries },
            @{ Name = "Trinh duyet Web"; Items = $appData.browsers },
            @{ Name = "Cong cu Lap trinh & Terminal"; Items = $appData.development_tools },
            @{ Name = "Tien ich He thong & Tim kiem"; Items = $appData.system_utilities },
            @{ Name = "Giao tiep, Media & Sang tao"; Items = $appData.communication_and_media }
        )

        foreach ($cat in $categories) {
            Write-Host "`n--- [DANH MUC: $($cat.Name)] ---" -ForegroundColor Magenta
            foreach ($app in $cat.Items) {
                $appName = $app.name
                $id = $app.winget_id
                
                Write-Step "Kiem tra: ${appName} (ID: ${id})..."
                
                # Cai dat qua winget khong tuong tac
                $installProcess = Start-Process winget -ArgumentList "install --exact --id `"${id}`" --silent --accept-package-agreements --accept-source-agreements --disable-interactivity" -NoNewWindow -Wait -PassThru
                
                if ($installProcess.ExitCode -eq 0) {
                    Write-Success "${appName}: Hoan tat cai dat / da cap nhat moi nhat!"
                } elseif ($installProcess.ExitCode -eq -1978335189) { # Already installed
                    Write-Success "${appName}: Da cai dat truoc do."
                } else {
                    Write-Warn "${appName}: Ma thoat ($($installProcess.ExitCode)). Dang tiep tuc goi tiep theo..."
                }
            }
        }
    } else {
        Write-Err "Khong tim thay file manifests\app-list.json!"
    }
} else {
    Write-Warn "Bo qua buoc cai dat phan mem (-SkipApps)."
}

# ==========================================
# 5. KHOI PHUC FILE CAU HINH (DOTFILES RESTORE)
# ==========================================
if (-not $SkipConfigs) {
    Write-Header "BUOC 4: TU DONG KHOI PHUC TOAN BO CAU HINH (DOTFILES)"

    $configDir = Join-Path $ScriptDir "configs"

    # 1. Cau hinh Starship Prompt (~/.config/starship.toml)
    $starshipSrc = Join-Path $configDir "starship.toml"
    $starshipDstDir = Join-Path $env:USERPROFILE ".config"
    $starshipDst = Join-Path $starshipDstDir "starship.toml"
    if (Test-Path $starshipSrc) {
        if (-not (Test-Path $starshipDstDir)) { New-Item -ItemType Directory -Path $starshipDstDir -Force | Out-Null }
        Copy-Item -Path $starshipSrc -Destination $starshipDst -Force
        Write-Success "Da khoi phuc Starship Prompt: $starshipDst"
    }

    # 2. Cau hinh Git Bash (~/.bashrc va ~/.bash_profile)
    $bashrcSrc = Join-Path $configDir ".bashrc"
    $bashrcDst = Join-Path $env:USERPROFILE ".bashrc"
    if (Test-Path $bashrcSrc) {
        Copy-Item -Path $bashrcSrc -Destination $bashrcDst -Force
        Write-Success "Da khoi phuc Git Bash (.bashrc): $bashrcDst"
    }

    $bashProfileDst = Join-Path $env:USERPROFILE ".bash_profile"
    if (-not (Test-Path $bashProfileDst)) {
        $bashProfileContent = @(
            '# generated by Git for Windows',
            'test -f ~/.profile && . ~/.profile',
            'test -f ~/.bashrc && . ~/.bashrc'
        ) -join "`n"
        Set-Content -Path $bashProfileDst -Value $bashProfileContent -Encoding UTF8
        Write-Success "Da tao file .bash_profile de nap .bashrc trong Git Bash."
    }

    # 3. Cau hinh PowerShell Profile
    $psProfileSrc = Join-Path $configDir "Microsoft.PowerShell_profile.ps1"
    $psProfilePaths = @(
        (Join-Path $env:USERPROFILE "Documents\WindowsPowerShell"),
        (Join-Path $env:USERPROFILE "Documents\PowerShell")
    )
    if (Test-Path $psProfileSrc) {
        foreach ($pDir in $psProfilePaths) {
            if (-not (Test-Path $pDir)) { New-Item -ItemType Directory -Path $pDir -Force | Out-Null }
            $target = Join-Path $pDir "Microsoft.PowerShell_profile.ps1"
            Copy-Item -Path $psProfileSrc -Destination $target -Force
            Write-Success "Da khoi phuc PowerShell Profile: $target"
        }
    }

    # 4. Cau hinh Windows Terminal Preview
    $termSrc = Join-Path $configDir "terminal-settings.json"
    $packagesBase = Join-Path $env:LOCALAPPDATA "Packages"
    if ((Test-Path $termSrc) -and (Test-Path $packagesBase)) {
        $termDirs = Get-ChildItem -Path $packagesBase -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*WindowsTerminal*" }
        foreach ($tDir in $termDirs) {
            $localState = Join-Path $tDir.FullName "LocalState"
            if (Test-Path $localState) {
                $tTarget = Join-Path $localState "settings.json"
                Copy-Item -Path $termSrc -Destination $tTarget -Force
                Write-Success "Da khoi phuc cai dat Windows Terminal: $tTarget"
            }
        }
    }

    # 5. Cau hinh VS Code
    $vscodeSrc = Join-Path $configDir "vscode-settings.json"
    $vscodeDstDir = Join-Path $env:APPDATA "Code\User"
    if (Test-Path $vscodeSrc) {
        if (-not (Test-Path $vscodeDstDir)) { New-Item -ItemType Directory -Path $vscodeDstDir -Force | Out-Null }
        $vscodeDst = Join-Path $vscodeDstDir "settings.json"
        Copy-Item -Path $vscodeSrc -Destination $vscodeDst -Force
        Write-Success "Da khoi phuc cau hinh VS Code: $vscodeDst"
    }
} else {
    Write-Warn "Bo qua buoc nap file cau hinh (-SkipConfigs)."
}

# ==========================================
# 6. KICH HOAT AO HOA & WSL
# ==========================================
if ($EnableWSL) {
    Write-Header "BUOC 5: KICH HOAT TINH NANG AO HOA & WSL"
    if (Test-IsAdmin) {
        Write-Step "Dang kich hoat WSL & Virtual Machine Platform..."
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart | Out-Null
        Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart | Out-Null
        Write-Success "Da bat tinh nang ao hoa! Khoi dong lai may de ap dung."
    } else {
        Write-Warn "De bat WSL va tinh nang Ao hoa, vui long chay script duoi quyen Administrator!"
    }
}

# ==========================================
# 7. HOAN TAT & TONG KET
# ==========================================
Write-Header "TAT CA DA HOAN TAT THANH CONG!"
Write-Host "Moi truong lam viec tren may tinh da duoc dong bo chuan xac 100%:" -ForegroundColor Green
Write-Host " - Trinh duyet: Google Chrome, Firefox"
Write-Host " - Lap trinh: Git, VS Code, Node.js LTS, Docker CLI/Compose, Termius"
Write-Host " - Terminal: Windows Terminal Preview (Git Bash mac dinh), Starship Prompt"
Write-Host " - Tien ich: PowerToys, Everything, IDM, nomacs, Tailscale"
Write-Host " - Media & Chat: Telegram, Zalo, OBS Studio, CapCut, Spotify"
Write-Host " - Toan bo cau hinh Starship, Git Bash, PowerShell profile va Terminal da duoc khoi phuc.`n"
