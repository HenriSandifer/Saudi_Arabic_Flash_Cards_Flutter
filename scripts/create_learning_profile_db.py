import sqlite3
import csv
import os

# === PATHS
DB_PATH = r"C:\Users\Henri\Documents\GitHub\Saudi_Arabic_Flash_Cards_Flutter\saudi_arabic_flash_cards_flutter\assets\learning_profile.db"
VOCAB_CSV_PATH = r"C:\Users\Henri\Documents\GitHub\Saudi_Arabic_Flash_Cards_Flutter\saudi_arabic_flash_cards_flutter\assets\data\vocab\vocab.csv"

# === Create DB and Tables
conn = sqlite3.connect(DB_PATH)
cursor = conn.cursor()

# === Create vocab table
cursor.execute("""
CREATE TABLE IF NOT EXISTS vocab (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    arabic_word TEXT,
    transliteration TEXT,
    english TEXT,
    category TEXT,
    type TEXT,
    notes TEXT,
    dialect TEXT,
    audio_path TEXT,
    status TEXT DEFAULT 'new',
    priority INTEGER DEFAULT 0,
    last_seen DATETIME
)
""")

# === Create user_prefs table
cursor.execute("""
CREATE TABLE IF NOT EXISTS user_prefs (
    key TEXT PRIMARY KEY,
    value TEXT
)
""")

# === Load vocab.csv
with open(VOCAB_CSV_PATH, "r", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        cursor.execute("""
            INSERT INTO vocab (
                arabic_word, transliteration, english, category, type, notes, dialect, audio_path
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            row["arabic_word"],
            row["transliteration"],
            row["english"],
            row["category"],
            row["type"],
            row["notes"],
            row["dialect"],
            row["audio_path"]
        ))

conn.commit()
conn.close()

print("✅ vocab table created and filled. user_prefs initialized.")
