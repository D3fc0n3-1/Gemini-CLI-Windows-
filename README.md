Gemini-CLI-Windows 🚀

A streamlined way to integrate Google's Gemini AI into the Windows 11 Command Prompt and PowerShell. This project provides a global gemini command that you can use to interact with AI directly from your terminal.
🛠 Prerequisites

    Windows 11

    Python 3.10+ (Install via winget install -e --id Python.Python.3.11)

    Gemini API Key: Get it free at Google AI Studio

📦 Installation
1. Set Up the Environment

Run these commands in your Command Prompt to create a dedicated, clean environment for the CLI:
Code snippet

mkdir "%USERPROFILE%\GeminiCLI"
cd /d "%USERPROFILE%\GeminiCLI"
python -m venv venv
call venv\Scripts\activate
pip install -U google-genai

2. Configure Your API Key

Add your key to your Windows User Environment Variables so it’s available globally:
PowerShell

# Run this in PowerShell (replace YOUR_KEY)
[Environment]::SetEnvironmentVariable("GOOGLE_API_KEY", "YOUR_KEY_HERE", "User")

Restart your terminal after this step.
3. PowerShell Profile Integration

Add the following function to your PowerShell profile to enable the gemini command:

    Open profile: notepad $PROFILE

    Paste this code:

PowerShell

function Get-Gemini {
    param([Parameter(Mandatory=$true, Position=0)][string]$Prompt)
    $PythonExe = "$env:USERPROFILE\GeminiCLI\venv\Scripts\python.exe"
    $Script = @"
from genai import Client
import os, sys
client = Client(api_key=os.environ.get('GOOGLE_API_KEY'))
try:
    response = client.models.generate_content(model='gemini-1.5-flash', contents=sys.argv[1])
    print(response.text)
except Exception as e:
    print(f'Error: {str(e)}')
"@
    & $PythonExe -c $Script $Prompt
}
Set-Alias -Name gemini -Value Get-Gemini

🚀 Usage

Simply type gemini followed by your question in any PowerShell window:
PowerShell

gemini "Explain how to secure a 1998 Econoline van's internal network"
