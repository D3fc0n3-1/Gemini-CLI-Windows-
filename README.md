# Gemini-CLI-Windows-
installer for Command prompt and Power Shell


PowerShell Profile integration

Step 1: Create the PowerShell Integration

We will create a function that handles the API call and alias it to the command gemini.

    Open PowerShell.

    Type notepad $PROFILE and hit Enter. (If it asks to create a new file, say Yes).

    Paste the following code into that file:

PowerShell

# Gemini CLI Integration for PowerShell
function Get-Gemini {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Prompt
    )

    # Path to your Python Virtual Env created earlier
    $PythonExe = "$env:USERPROFILE\GeminiCLI\venv\Scripts\python.exe"
    
    # Inline Python script to handle the API call
    $Script = @"
import google.generativeai as genai
import os
import sys

api_key = os.environ.get('GOOGLE_API_KEY')
if not api_key:
    print('Error: GOOGLE_API_KEY environment variable not set.')
    sys.exit(1)

genai.configure(api_key=api_key)
model = genai.GenerativeModel('gemini-1.5-flash')
try:
    response = model.generate_content(sys.argv[1])
    print(response.text)
except Exception as e:
    print(f'Error: {str(e)}')
"@

    # Execute via Python venv
    & $PythonExe -c $Script $Prompt
}

# Create the Alias
Set-Alias -Name gemini -Value Get-Gemini

    Save and close Notepad.

    Reload your profile by running: . $PROFILE

Step 2: Set the Global Environment Variable

For the command to work in both CMD and PowerShell without re-entering your key, we need to set it at the User level.

Run this once in PowerShell (replace the placeholder with your actual key):
PowerShell

[Environment]::SetEnvironmentVariable("GOOGLE_API_KEY", "your_actual_key_here", "User")

Note: You will need to restart your terminal window for this global change to take effect.
Step 3: Usage in Both Terminals
In PowerShell:

You can now use it like a native cmdlet. Because of your cybersecurity background, you’ll appreciate that this method keeps the prompt as a string object:
PowerShell

gemini "Write a quick powershell script to audit open ports on this machine"

In Command Prompt (CMD):

Since the Python virtual environment is already set up, you can call it directly from CMD using this one-liner syntax:
DOS

%USERPROFILE%\GeminiCLI\venv\Scripts\python.exe -c "import google.generativeai as g; import os; g.configure(api_key=os.environ['GOOGLE_API_KEY']); print(g.GenerativeModel('gemini-1.5-flash').generate_content('Hello from CMD').text)"
