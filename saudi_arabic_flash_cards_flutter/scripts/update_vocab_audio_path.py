import json
import re

# === Helper to sanitize filenames
def sanitize_filename(text):
    return re.sub(r'[^\w\-_.]', '_', text)

# === Load vocab.json
with open("assets/data/vocab/vocab.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# === Update audio_path
for entry in data:
    word = entry.get("arabic_word", "")
    sanitized = sanitize_filename(word)
    entry["audio_path"] = f"assets/audio/vocab/{sanitized}.mp3"

# === Save updated vocab.json
with open("assets/data/vocab/vocab.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("✅ vocab.json updated with correct audio paths.")
