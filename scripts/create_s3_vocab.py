import json

# Settings
S3_BASE_URL = "https://saudi-arabic-flash-cards.s3.amazonaws.com/audio/"

# Load your current vocab.json
with open(r"C:\Users\Henri\Documents\GitHub\Saudi_Arabic_Flash_Cards_Flutter\saudi_arabic_flash_cards_flutter\assets\vocab.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# Update audio paths
for entry in data:
    filename = entry.get("audio_path", "").split("/")[-1]
    entry["audio_path"] = f"{S3_BASE_URL}{filename}"

# Save updated version
with open("s3_vocab.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("✅ s3_vocab.json created with full S3 URLs.")
