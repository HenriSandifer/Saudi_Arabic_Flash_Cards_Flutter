import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'services/database_helper.dart';

class FlashcardPage extends StatefulWidget {
  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  List<Map<String, dynamic>> vocabList = [];
  Map<String, dynamic>? currentWord;
  bool revealed = false;
  Color? feedbackColor;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    loadNextWord();
  }

  Future<void> loadNextWord() async {
    final dbWord = await DatabaseHelper.instance.getNextFlashcard();
    if (dbWord == null) return;

    setState(() {
      currentWord = dbWord;
      revealed = false;
      feedbackColor = null;
    });

    if (dbWord["status"] == "new") {
      await DatabaseHelper.instance.markVocabSeen(dbWord["id"] as int);
    }
  }

  void playAudio(String path) async {
    await player.stop();
    await player.play(AssetSource(path.replaceFirst("assets/", "")));
  }

  void handleButtonPress(String type) async {
    if (currentWord == null) return;
    final id = currentWord!["id"] as int;
    await DatabaseHelper.instance.logFlashcardInteraction(id, type);
    await loadNextWord();
  }

  @override
  Widget build(BuildContext context) {
    if (currentWord == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Flashcards")),
        body: Center(child: Text("No flashcards found.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Flashcards")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Spacer(),
            ElevatedButton(
              onPressed: () => setState(() => revealed = true),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 80),
                backgroundColor: Colors.teal[100],
              ),
              child: Text(
                revealed ? currentWord!["arabic_word"] : currentWord!["english"],
                style: TextStyle(fontSize: 32),
              ),
            ),
            if (revealed) ...[
              SizedBox(height: 12),
              Text(currentWord!["transliteration"], style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
              Text(currentWord!["english"], style: TextStyle(fontSize: 16)),
              SizedBox(height: 12),
              Text(currentWord!["transliteration"]),
              Text(currentWord!["english"]),
              Text(currentWord!["category"]),
              Text(currentWord!["type"]),
              Text(currentWord!["notes"]),
              Text(currentWord!["dialect"]),
              ElevatedButton(
                onPressed: () => playAudio(currentWord!["audio_path"]),
                child: Icon(Icons.volume_up),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => feedbackColor = Colors.green);
                      await Future.delayed(Duration(milliseconds: 200)); // brief color delay
                      handleButtonPress("right");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: feedbackColor == Colors.green ? Colors.green : null,
                    ),
                    child: Text("Right"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => feedbackColor = Colors.blue);
                      await Future.delayed(Duration(milliseconds: 200));
                      handleButtonPress("practice");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: feedbackColor == Colors.blue ? Colors.blue : null,
                    ),
                    child: Text("Practice"),
                  ),
                ],
              ),
            ],
            Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              child: Text("Menu"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48)),
            ),
          ],
        ),
      ),
    );
  }
}
