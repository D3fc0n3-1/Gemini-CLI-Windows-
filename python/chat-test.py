import google.generativeai as genai
import os

genai.configure(api_key=os.environ["GOOGLE_API_KEY"])
model = genai.GenerativeModel('gemini-1.5-flash')

response = model.generate_content("Give me a quick update on your new capabilities")
print(response.text)
