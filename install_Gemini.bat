@echo off
SETLOCAL EnableDelayedExpansion

echo Checking for Python...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found. Installing via Winget...
    winget install -e --id Python.Python.3.11
    echo Please restart this script after the Python installation completes.
    pause
    exit
)

echo Creating a dedicated directory for Gemini CLI...
if not exist "%USERPROFILE%\GeminiCLI" mkdir "%USERPROFILE%\GeminiCLI"
cd /d "%USERPROFILE%\GeminiCLI"

echo Setting up Virtual Environment...
python -m venv venv
call venv\Scripts\activate

echo Installing Google Generative AI package...
pip install -q -U google-generativeai

echo.
echo ---------------------------------------------------
echo SETUP COMPLETE
echo ---------------------------------------------------
echo To use Gemini, you need an API Key from: 
echo https://aistudio.google.com/app/apikey
echo.
echo To run your CLI tools in the future, navigate to:
echo %USERPROFILE%\GeminiCLI and run 'venv\Scripts\activate'
echo ---------------------------------------------------
pause
