<#
.SYNOPSIS
    Setup script for Gemini-CLI-Windows.
    Automates Python venv creation and library installation.
#>

$InstallDir = "$env:USERPROFILE\GeminiCLI"
$ApiKey = Read-Host -Prompt "Enter your Gemini API Key (from AI Studio)"

Write-Host "--- Starting Gemini CLI Setup ---" -ForegroundColor Cyan

# 1. Create Directory
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir | Out-Null
    Write-Host "[+] Created directory: $InstallDir"
}

# 2. Setup Virtual Environment
Write-Host "[*] Creating Python Virtual Environment..." -ForegroundColor Yellow
Set-Location $InstallDir
python -m venv venv

# 3. Install latest Google GenAI SDK
Write-Host "[*] Installing google-genai SDK..." -ForegroundColor Yellow
.\venv\Scripts\python.exe -m pip install -U -q google-genai

# 4. Set Environment Variable
Write-Host "[*] Setting User Environment Variable..." -ForegroundColor Yellow
[Environment]::SetEnvironmentVariable("GOOGLE_API_KEY", $ApiKey, "User")

Write-Host "--- Setup Complete! ---" -ForegroundColor Green
Write-Host "1. Restart your terminal to refresh Environment Variables."
Write-Host "2. Add the function from README.md to your `$PROFILE`."
pause
