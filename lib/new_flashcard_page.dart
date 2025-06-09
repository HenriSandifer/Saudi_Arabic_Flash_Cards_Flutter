import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'services/database_helper.dart';

class FlashcardPage extends StatefulWidget {
  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  List<dynamic> vocabList = [];
  Map<String, dynamic>? currentWord;
  bool revealed = false;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    loadVocab();
  }

  Future<void> loadVocab() async {
    final dbWord = await DatabaseHelper.instance.getNextFlashcard();
    if (dbWord != null) {
      setState(() {
        currentWord = dbWord;
        revealed = false;
      });
    }
  }

  void revealCard() async {
    if (currentWord != null && currentWord!["status"] == "new") {
      await DatabaseHelper.instance.markVocabSeen(currentWord!["id"]);
    }
    setState(() {
      revealed = true;
    });
  }

  void logChoice(String type) async {
    if (currentWord != null) {
      await DatabaseHelper.instance.logFlashcardInteraction(currentWord!["id"], type);
    }
    await loadVocab();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flash Cards")),
      body: currentWord == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  if (!revealed)
                    ElevatedButton(
                      onPressed: revealCard,
                      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 100)),
                      child: Text(
                        currentWord!["english"] ?? "",
                        style: TextStyle(fontSize: 28),
                      ),
                    )
                  else ...[
                    ElevatedButton(
                      onPressed: () {
                        final path = currentWord!["audio_path"].replaceFirst("assets/", "");
                        player.play(AssetSource(path));
                      },
                      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 100)),
                      child: Text(
                        currentWord!["arabic_word"] ?? "",
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Transliteration: ${currentWord!["transliteration"]}"),
                    Text("English: ${currentWord!["english"]}"),
                    Text("Category: ${currentWord!["category"]}"),
                    if (currentWord!["type"] != null) Text("Type: ${currentWord!["type"]}"),
                    if (currentWord!["notes"] != null) Text("Notes: ${currentWord!["notes"]}"),
                    if (currentWord!["dialect"] != null) Text("Dialect: ${currentWord!["dialect"]}"),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => logChoice("right"),
                          child: Text("Right"),
                        ),
                        ElevatedButton(
                          onPressed: () => logChoice("practice"),
                          child: Text("Practice"),
                        )
                      ],
                    )
                  ],
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, "/"),
                    child: Text("Menu"),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48)),
                  ),
                ],
              ),
            ),
    );
  }
}
