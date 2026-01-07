# Gemini-CLI-Windows 🚀

A streamlined way to integrate Google's Gemini AI into the Windows 11 Command Prompt and PowerShell. This project provides a global `gemini` command to interact with AI directly from your terminal.

"Download the latest gemini.exe from the Releases page, add your GOOGLE_API_KEY to your environment variables, and you're ready to go."

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
        [switch]$Pro,
        [switch]$List
    )
    begin { $InputText = "" }
    process { if ($_) { $InputText += "$_`n" } }
    end {
        $PythonExe = "$env:USERPROFILE\GeminiCLI\venv\Scripts\python.exe"
        
        if ($List) {
            $ListCmd = "from google import genai; import os; client = genai.Client(api_key=os.environ.get('GOOGLE_API_KEY'), http_options={'api_version': 'v1beta'});" +
                       "print('\nAvailable Models:'); [print(f'- {m.name}') for m in client.models.list()]"
            & $PythonExe -c $ListCmd
            return
        }

        # Set the target and the fallback
        $Primary = if ($Pro) { "models/gemini-2.5-pro" } else { "models/gemini-3-flash-preview" }
        $Fallback = "models/gemini-3-flash-preview"
        $FinalPrompt = if ($InputText) { "$Prompt`n`nCONTEXT/DATA:`n$InputText" } else { $Prompt }
        
        if (-not $FinalPrompt) { return }

        $Cmd = @"
from google import genai
import os, sys
client = genai.Client(api_key=os.environ.get('GOOGLE_API_KEY'), http_options={'api_version': 'v1beta'})
primary_model = sys.argv[1]
fallback_model = sys.argv[2]
prompt = sys.argv[3]

try:
    # Try the requested model first
    response = client.models.generate_content(model=primary_model, contents=prompt)
    print(response.text)
except Exception as e:
    if '429' in str(e):
        print(f'-- Quota hit on {primary_model}. Falling back to {fallback_model}... --', file=sys.stderr)
        try:
            response = client.models.generate_content(model=fallback_model, contents=prompt)
            print(response.text)
        except Exception as e2:
            print(f'Critical Error: {str(e2)}', file=sys.stderr)
    else:
        print(f'Error: {str(e)}', file=sys.stderr)
"@
        & $PythonExe -c $Cmd $Primary $Fallback $FinalPrompt
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
