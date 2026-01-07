import os
import sys
import argparse
from google import genai

def main():
    parser = argparse.ArgumentParser(description="Gemini CLI for Windows")
    parser.add_argument("prompt", nargs="?", help="The prompt to send to Gemini")
    parser.add_argument("-pro", action="store_true", help="Use Gemini 2.5 Pro")
    args = parser.parse_args()

    # Handle piped input
    piped_data = ""
    if not sys.stdin.isatty():
        piped_data = sys.stdin.read()

    final_prompt = args.prompt if args.prompt else ""
    if piped_data:
        final_prompt = f"{final_prompt}\n\nCONTEXT/DATA:\n{piped_data}"

    if not final_prompt:
        print("Error: No prompt or piped data provided.")
        sys.exit(1)

    api_key = os.environ.get('GOOGLE_API_KEY')
    if not api_key:
        print("Error: GOOGLE_API_KEY environment variable not set.")
        sys.exit(1)

    client = genai.Client(api_key=api_key, http_options={'api_version': 'v1beta'})
    model_name = "models/gemini-2.5-pro" if args.pro else "models/gemini-3-flash-preview"

    try:
        response = client.models.generate_content(model=model_name, contents=final_prompt)
        print(response.text)
    except Exception as e:
        print(f"API Error: {str(e)}")

if __name__ == "__main__":
    main()