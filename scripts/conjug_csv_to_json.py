import pandas as pd
import json
from collections import defaultdict

# Load the CSV
df = pd.read_csv(r"C:\Users\Henri\Documents\GitHub\Saudi_Arabic_Flash_Cards_Flutter\saudi_arabic_flash_cards_flutter\assets\conjugation\conjugation.csv", encoding="utf-8")

# Create a dictionary grouped by root verb
verbs = defaultdict(lambda: {
    "translit": "",
    "meaning": "",
    "forms": {
        "past": {},
        "present": {},
        "future": {}
    }
})

for _, row in df.iterrows():
    root = row['verb_root_ar']
    verbs[root]["translit"] = row["verb_root_translit"]
    verbs[root]["meaning"] = row["verb_meaning_en"]

    tense = row["tense"]
    person = row["person_code"]

    verbs[root]["forms"][tense][person] = {
        "ar": row["arabic"],
        "tr": row["translit"],
        "en": row["english"]
    }

# Convert to list
conjugation_list = []
for root, data in verbs.items():
    conjugation_list.append({
        "verb": root,
        "translit": data["translit"],
        "meaning": data["meaning"],
        "forms": data["forms"]
    })

# Save to JSON
with open("conjugation.json", "w", encoding="utf-8") as f:
    json.dump(conjugation_list, f, ensure_ascii=False, indent=2)

print("✅ conjugation.json created successfully!")
