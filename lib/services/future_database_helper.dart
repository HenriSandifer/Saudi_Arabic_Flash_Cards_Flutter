import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data'; // for ByteData
import 'dart:io'; // for File
import 'package:flutter/services.dart'; // for rootBundle

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;

  DatabaseHelper._init();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "learning_profile.db");

    final exists = await databaseExists(path);
    if (!exists) {
      print("⏳ Copying preloaded DB...");
      ByteData data = await rootBundle.load("assets/learning_profile.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      print("✅ DB copied to $path");
    }

    return await openDatabase(path);
  }


  Future<Map<String, dynamic>?> getNextFlashcard() async {
    final db = await instance.db;

    // Try unseen words first
    final unseen = await db.query("vocab", where: "status = 'new'");
    if (unseen.isNotEmpty) {
      final shuffled = List<Map<String, dynamic>>.from(unseen)..shuffle();
      return shuffled.first;
    }

final results = await db.rawQuery("""
  SELECT p.*
  FROM phrase p
  JOIN phrase_structure ps ON p.id = ps.phrase_id
  JOIN structure s ON ps.structure_id = s.id
  JOIN phrase_function pf ON p.id = pf.phrase_id
  JOIN function f ON pf.function_id = f.id
  JOIN phrase_utility pu ON p.id = pu.phrase_id
  JOIN utility u ON pu.utility_id = u.id
  WHERE s.name = 'negation'
    AND f.name = 'asking for information'
    AND u.name = 'high frequency';


if (rows.isNotEmpty) {
      final shuffled = List<Map<String, dynamic>>.from(rows)..shuffle();
      return shuffled.first;
    }

    // Fallback: return any vocab at random
    final all = await db.query("vocab");
    if (all.isNotEmpty) {
      final shuffled = List<Map<String, dynamic>>.from(all)..shuffle();
      return shuffled.first;
    }
    return null;
  }

  Future<void> markVocabSeen(int vocabId) async {
    final db = await instance.db;
    await db.update(
      "vocab",
      {"status": "seen", "last_seen": DateTime.now().toIso8601String()},
      where: "id = ?",
      whereArgs: [vocabId],
    );
  }

  Future<void> logFlashcardInteraction(int vocabId, String type) async {
    final db = await instance.db;
    print("🔍 logFlashcardInteraction called: vocabId=$vocabId, type=$type");

    final existing = await db.query(
      "flashcard_log",
      where: "vocab_id = ?",
      whereArgs: [vocabId],
    );

    if (existing.isEmpty) {
      print("📥 Inserting new log row...");
      await db.insert("flashcard_log", {
        "vocab_id": vocabId,
        "right_count": type == "right" ? 1 : 0,
        "practice_count": type == "practice" ? 1 : 0,
        "last_shown": DateTime.now().toIso8601String(),
      });
    } else {
      print("🛠 Updating existing row...");
      final row = existing.first;
      final updated = {
        "right_count": (row["right_count"] as int) + (type == "right" ? 1 : 0),
        "practice_count":
            (row["practice_count"] as int) + (type == "practice" ? 1 : 0),
        "last_shown": DateTime.now().toIso8601String(),
      };
      await db.update(
        "flashcard_log",
        updated,
        where: "vocab_id = ?",
        whereArgs: [vocabId],
      );
    }
  }
}
