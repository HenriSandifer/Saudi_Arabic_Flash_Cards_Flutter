import sqlite3
import datetime

# === Connect to your existing DB
DB_PATH = r"C:\Users\Henri\Documents\GitHub\Saudi_Arabic_Flash_Cards_Flutter\saudi_arabic_flash_cards_flutter\assets\learning_profile.db"
conn = sqlite3.connect(DB_PATH)
cursor = conn.cursor()

# === Create flashcard_log table
cursor.execute("""
CREATE TABLE IF NOT EXISTS flashcard_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    vocab_id INTEGER,
    right_count INTEGER DEFAULT 0,
    practice_count INTEGER DEFAULT 0,
    last_shown DATETIME,
    FOREIGN KEY (vocab_id) REFERENCES vocab(id)
)
""")

# === Create grammar table
cursor.execute("""
CREATE TABLE IF NOT EXISTS grammar (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    concept TEXT,
    description TEXT,
    usage_count INTEGER DEFAULT 0,
    last_used DATETIME,
    priority INTEGER DEFAULT 0
)
""")

# === Create daily_sentences table
cursor.execute("""
CREATE TABLE IF NOT EXISTS daily_sentences (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sentence_ar TEXT,
    sentence_tr TEXT,
    sentence_en TEXT,
    audio_path TEXT,
    date_created DATE DEFAULT CURRENT_DATE,
    user_rating TEXT,
    interacted INTEGER DEFAULT 0
)
""")

# === Insert starter grammar entries
starter_grammar = [
    ("past tense", "Used to describe completed actions."),
    ("present tense", "Used for ongoing or habitual actions."),
    ("future tense", "Describes actions that will happen."),
    ("object pronouns", "Me, you, him, her, etc."),
    ("prepositions", "e.g., in, on, to, from (في، على، إلى...)")
]

cursor.executemany("""
    INSERT INTO grammar (concept, description) VALUES (?, ?)
""", starter_grammar)

# === Insert one dummy daily sentence (to test rendering later)
cursor.execute("""
    INSERT INTO daily_sentences (
        sentence_ar, sentence_tr, sentence_en, audio_path, date_created, user_rating, interacted
    ) VALUES (?, ?, ?, ?, ?, ?, ?)
""", (
    "أنا أحب القهوة", "ana uḥibb al-qahwa", "I love coffee", "audio/daily/2024-05-27_1.mp3",
    datetime.date.today().isoformat(), "easy", 0
))

conn.commit()
conn.close()

print("✅ flashcard_log, grammar, and daily_sentences tables created with starter data.")
