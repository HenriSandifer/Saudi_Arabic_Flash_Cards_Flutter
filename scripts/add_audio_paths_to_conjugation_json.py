import json
import os

INPUT_PATH = r"C:\Users\Henri\Documents\GitHub\Saudi_Arabic_Flash_Cards_Flutter\saudi_arabic_flash_cards_flutter\assets\data\conjugation\conjugation.json"
OUTPUT_PATH = r"conjugation_with_audio.json"
AUDIO_FOLDER = "C:\Users\Henri\Documents\GitHub\Saudi_Arabic_Flash_Cards_Flutter\saudi_arabic_flash_cards_flutter\assets\audio\conjugation"

with open(INPUT_PATH, "r", encoding="utf-8") as f:
    data = json.load(f)

for verb in data:
    root = verb["translit"]
    for tense, entries in verb["forms"].items():
        for person_code, form in entries.items():
            filename = f"{root}_{tense}_{person_code}.mp3"
            filepath = os.path.join(AUDIO_FOLDER, filename).replace("\\", "/")
            form["audio_path"] = filepath

with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("✅ audio paths added to conjugation.json")
