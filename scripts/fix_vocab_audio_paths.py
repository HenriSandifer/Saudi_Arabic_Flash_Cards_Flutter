import sqlite3
import re

DB_PATH = r"C:\Users\Henri\Documents\GitHub\Saudi_Arabic_Flash_Cards_Flutter\saudi_arabic_flash_cards_flutter\assets\learning_profile.db"

conn = sqlite3.connect(DB_PATH)
cursor = conn.cursor()

cursor.execute("SELECT id, audio_path FROM vocab")
rows = cursor.fetchall()
updated = 0

for row in rows:
    id, path = row
    if path:
        # Extract just the filename from any format
        match = re.search(r"([-\w\d_]+\.(mp3|wav))", path)
        if match:
            filename = match.group(1)
            new_path = f"assets/audio/vocab/{filename}"
            cursor.execute("UPDATE vocab SET audio_path = ? WHERE id = ?", (new_path, id))
            print(f"✅ ID {id} → {new_path}")
            updated += 1

conn.commit()
conn.close()

print(f"🎉 Updated {updated} paths.")
