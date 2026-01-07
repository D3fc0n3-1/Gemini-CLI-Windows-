Gemini CLI PowerShell Integration

A lightweight, local integration to bring Google Gemini AI capabilities directly into the Windows PowerShell and Command Prompt (CMD) environments.
Overview

This setup creates a global gemini command in your terminal. It leverages a Python virtual environment to keep your system clean and uses Windows Environment Variables to securely handle your API keys.
Prerequisites

    Windows 11

    Python 3.10+

    Gemini API Key: Obtain one from the Google AI Studio.

Installation
1. Automated Environment Setup

Run the following commands in a standard Command Prompt (CMD) to create the directory structure and install the necessary libraries.
Code snippet

mkdir "%USERPROFILE%\GeminiCLI"
cd /d "%USERPROFILE%\GeminiCLI"
python -m venv venv
call venv\Scripts\activate
pip install -U google-generativeai

2. Configure API Key

Set your API key as a persistent User environment variable. Replace YOUR_API_KEY with your actual key.

PowerShell:
PowerShell

[Environment]::SetEnvironmentVariable("GOOGLE_API_KEY", "YOUR_API_KEY", "User")

Note: Restart your terminal after running this for the changes to take effect.
3. PowerShell Profile Integration

To use the gemini command natively in PowerShell, add the following function to your profile.

    Open your profile in Notepad: notepad $PROFILE

    Append the following code:

PowerShell

# Gemini CLI Integration
function Get-Gemini {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Prompt
    )

    $PythonExe = "$env:USERPROFILE\GeminiCLI\venv\Scripts\python.exe"
    
    $Script = @"
import google.generativeai as genai
import os
import sys

api_key = os.environ.get('GOOGLE_API_KEY')
if not api_key:
    print('Error: GOOGLE_API_KEY not found in environment variables.')
    sys.exit(1)

genai.configure(api_key=api_key)
model = genai.GenerativeModel('gemini-1.5-flash')
try:
    response = model.generate_content(sys.argv[1])
    print(response.text)
except Exception as e:
    print(f'Error: {str(e)}')
"@

    & $PythonExe -c $Script $Prompt
}

Set-Alias -Name gemini -Value Get-Gemini

Usage
PowerShell

Once configured, you can call Gemini from any directory:
PowerShell

gemini "Explain the difference between a TCP and UDP sweep in Nmap"

Command Prompt (CMD)

You can call the executable directly from CMD using the following syntax:
DOS

"%USERPROFILE%\GeminiCLI\venv\Scripts\python.exe" -c "import google.generativeai as g; import os; g.configure(api_key=os.environ['GOOGLE_API_KEY']); print(g.GenerativeModel('gemini-1.5-flash').generate_content('Hello from CMD').text)"

Security Considerations

    API Key Safety: This implementation uses EnvironmentVariableTarget.User to avoid hardcoding keys in scripts.

    Virtual Environment: By using a venv, we prevent version conflicts with other Python-based cybersecurity tools (like Impacket or Responder).
