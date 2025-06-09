import sqlite3

# Connect to DB file (creates it if not exists)
conn = sqlite3.connect('flashcard_app.db')
cursor = conn.cursor()

# Example table creation
cursor.execute("""
CREATE TABLE IF NOT EXISTS category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);
""")

# Always commit!
conn.commit()