import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // for rootBundle
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class FlashcardPage extends StatefulWidget {
  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardPage> {
  List<dynamic> vocabList = [];
  int currentIndex = 0;
  bool revealed = false;
  final player = AudioPlayer();
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    loadVocab();
  }

  Future<void> loadVocab() async {
    final String jsonString = await rootBundle.loadString('assets/data/vocab/vocab.json');
    final List<dynamic> data = json.decode(jsonString);
    setState(() {
      vocabList = data;
    });
  }

  final _random = Random();
  void nextCard() {
    setState(() {
      revealed = false;
      currentIndex = _random.nextInt(vocabList.length);
    });
  }

  void playAudio(String path) async {
    await player.stop();
    await player.play(AssetSource(path.replaceFirst("assets/", "")));
  }

  @override
  Widget build(BuildContext context) {
    if (vocabList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Loading...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final item = vocabList[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("Arabic Flashcards")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(),
            GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) {
                setState(() => _isPressed = false);
                if (!revealed) {
                  setState(() => revealed = true);
                } else {
                  playAudio(item['audio_path']);
                }
              },
              onTapCancel: () => setState(() => _isPressed = false),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                transform: _isPressed
                    ? Matrix4.translationValues(0, 4, 0)
                    : Matrix4.translationValues(0, 0, 0),
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isPressed
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(4, 4),
                            blurRadius: 6,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(-2, -2),
                            blurRadius: 2,
                          ),
                        ],
                ),
                child: Text(
                  revealed ? item['arabic_word'] : item['english'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            if (revealed) ...[
              Text("English: ${item['english']}"),
              Text("Transliteration: ${item['transliteration']}"),
              Text("Category: ${item['category']}"),
              Text("Type: ${item['type']}"),
              Text("Root: ${item['arabic_full']}"),
              SizedBox(height: 20),
            ],
            Spacer(),
            if (revealed)
              ElevatedButton(
                onPressed: nextCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shadowColor: Colors.black,
                  elevation: 6,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}
