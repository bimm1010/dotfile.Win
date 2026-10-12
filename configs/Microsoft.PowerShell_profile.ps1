# PowerShell Profile

# Alias Herdr
Set-Alias -Name her -Value herdr

# Khoi dong Starship Prompt cho PowerShell (neu da cai dat Starship)
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
