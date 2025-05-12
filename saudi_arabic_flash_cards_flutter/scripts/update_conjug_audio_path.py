import json
import os
import re

def sanitize(text):
    return re.sub(r'[^\w\-_.]', '_', text)

# Load existing JSON
with open("assets/data/conjugation/conjugation.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# Update audio_path
for verb in data:
    root = sanitize(verb["translit"])
    for tense, entries in verb["forms"].items():
        for person_code, form in entries.items():
            filename = f"{root}_{tense}_{person_code}.mp3"
            form["audio_path"] = f"assets/audio/conjugation/{filename}"

# Save updated JSON
with open("assets/data/conjugation/conjugation.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("✅ conjugation.json updated with correct audio paths.")
