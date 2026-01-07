# Gemini-CLI-Windows 🚀

A streamlined way to integrate Google's Gemini AI into the Windows 11 Command Prompt and PowerShell. This project provides a global `gemini` command to interact with AI directly from your terminal.

---

## 🛠 Prerequisites

- **Windows 11**
- **Python 3.10+** (Install via: `winget install -e --id Python.Python.3.11`)
- **Gemini API Key:** Obtain yours at [Google AI Studio](https://aistudio.google.com/app/apikey)

---

## 📦 Installation

### 1. Set Up the Environment
Run these commands in your Command Prompt to create a dedicated, clean environment:

```batch
mkdir "%USERPROFILE%\GeminiCLI"
cd /d "%USERPROFILE%\GeminiCLI"
python -m venv venv
call venv\Scripts\activate
pip install -U google-genai
```

2. Configure Your API Key

Set your key as a persistent User environment variable.

In PowerShell (Run as Administrator):
```PowerShell

[Environment]::SetEnvironmentVariable("GOOGLE_API_KEY", "YOUR_KEY_HERE", "User")
```

Note: Close and reopen your terminal after this step.
🐚 PowerShell Integration

To enable the gemini command natively, add the function below to your PowerShell profile.

Open your profile: ```notepad $PROFILE```

Paste the following block at the end of the file:

```PowerShell

function Get-Gemini {
    param(
        [Parameter(Mandatory=$false, Position=0, ValueFromPipeline=$true)]
        [string]$Prompt,
        
        [Parameter(Mandatory=$false)]
        [switch]$Pro
    )

    begin {
        $InputText = ""
    }
    process {
        if ($_) { $InputText += "$_`n" }
    }
    end {
        # Select model based on -Pro switch
        $ModelName = if ($Pro) { "gemini-1.5-pro" } else { "gemini-1.5-flash" }
        
        # Combine piped input with the prompt
        $FinalPrompt = if ($InputText) { "$Prompt`n`nCONTEXT/DATA:`n$InputText" } else { $Prompt }

        if (-not $FinalPrompt) {
            Write-Error "Please provide a prompt or pipe data to the command."
            return
        }

        $PythonExe = "$env:USERPROFILE\GeminiCLI\venv\Scripts\python.exe"
        
        $Script = @"
from genai import Client
import os
import sys

api_key = os.environ.get('GOOGLE_API_KEY')
if not api_key:
    print('Error: GOOGLE_API_KEY not found.')
    sys.exit(1)

client = Client(api_key=api_key)

try:
    # Model and prompt passed from PowerShell
    response = client.models.generate_content(
        model=sys.argv[1],
        contents=sys.argv[2]
    )
    print(response.text)
except Exception as e:
    print(f'Error: {str(e)}')
"@

        & $PythonExe -c $Script $ModelName $FinalPrompt
    }
}

Set-Alias -Name gemini -Value Get-Gemini
```

🚀 Usage

You can now call Gemini from any PowerShell window:
```PowerShell

gemini "Write a secure Python script for an air-gapped environment" -Pro
```

2. Piping Data (Log Analysis): If you have a log file or a command output, you can pipe it directly:
```PowerShell

Get-Content .\security_logs.txt | gemini "Analyze these logs for suspicious IP addresses"
```

3. Troubleshooting Network Issues:
```PowerShell

ipconfig /all | gemini "Explain my network configuration and check for DNS leaks"
```

📝 Troubleshooting

If you see a 404 or Model Not Found error, ensure you have updated to the latest SDK: pip install -U google-genai inside your %USERPROFILE%\GeminiCLI\venv environment.
