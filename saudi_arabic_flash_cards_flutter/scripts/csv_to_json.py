import pandas as pd
import json
import os
import re

# Helper to sanitize Arabic words for filenames
def sanitize_filename(text):
    return re.sub(r'[^\w\-_.]', '_', text)

# Load CSV
df = pd.read_csv(r"C:\Users\Henri\Documents\GitHub\Saudi_Arabic_Flash_Cards\data\vocab.csv")

# Fill NaNs with empty strings
df = df.fillna("")

# Add audio_path for each row
for i, row in df.iterrows():
    arabic_word = row["arabic_word"]
    sanitized = sanitize_filename(arabic_word)
    df.at[i, "audio_path"] = f"assets/audio/{sanitized}.mp3"

# Convert to JSON format
json_data = df.to_dict(orient="records")

# Save as JSON
with open(r"C:\Users\Henri\Documents\GitHub\Saudi_Arabic_Flash_Cards_Flutter\saudi_arabic_flash_cards_flutter\assets\vocab.json", "w", encoding="utf-8") as f:
    json.dump(json_data, f, ensure_ascii=False, indent=2)

print("✅ vocab.json created with audio paths!")
