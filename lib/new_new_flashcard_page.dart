import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'services/database_helper.dart';

const Color kColor1 = Color(0xFF44562f);
const Color kColor2 = Color(0xFFb3000c);
const Color kColor3 = Color(0xFFb7c88d);
const Color kColor4 = Color(0xFFe9dfb4);
const Color kColor5 = Color(0xFFefbfb3);
const Color kColor6 = Color(0xFF9f9fd0);
const Color kColor7 = Color(0xFF4b7c9b);
const Color kColor8 = Color(0xFFb1d8e7);

class FlashcardPage extends StatefulWidget {
  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  List<Map<String, dynamic>> vocabList = [];
  Map<String, dynamic>? currentWord;
  bool revealed = false;
  bool _isPressed = false;
  Color? feedbackColor;
  int currentIndex = 0;
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
            GestureDetector(
              onTapDown: (_) {
                setState(() => _isPressed = true);
              },
              onTapUp: (_) {
                setState(() => _isPressed = false);

                if (!revealed) {
                  setState(() => revealed = true);
                } else {
                  playAudio(currentWord!["audio_path"]);
                }
              },

              onTapCancel: () {
                setState(() => _isPressed = false);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                transform: _isPressed
                    ? Matrix4.translationValues(0, 4, 0)
                    : Matrix4.translationValues(0, 0, 0),
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: kColor4,
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
                  revealed ? currentWord!["arabic_word"] : currentWord!["english"],
                  style: TextStyle(color: revealed ? kColor2 : kColor1, fontWeight: FontWeight.bold, fontSize : 32),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            /*ElevatedButton(
              onPressed: () => setState(() => revealed = true),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 80),
                backgroundColor: kColor4,
              ),
              child: Text(
                revealed ? currentWord!["arabic_word"] : currentWord!["english"],
                style: TextStyle(fontSize: 32),
              ),
            ),*/
            if (revealed) ...[
              SizedBox(height: 12),
              Text(currentWord!["transliteration"], style: TextStyle(color: kColor1, fontSize: 20)),
              SizedBox(height: 4),
              Text(currentWord!["english"], style: TextStyle(color: kColor1, fontSize: 20), textAlign: TextAlign.center,),
              SizedBox(height: 12),
              Text(currentWord!["category"], style: TextStyle(color: kColor1, fontSize: 20)),
              Text(currentWord!["type"], style: TextStyle(color: kColor1, fontSize: 20)),
              Text(currentWord!["notes"], style: TextStyle(color: kColor1, fontSize: 20)),
              //Text(currentWord!["dialect"], style: TextStyle(color: kColor1, fontSize: 20)),
              // ElevatedButton(
               // onPressed: () => playAudio(currentWord!["audio_path"]),
                //child: Icon(Icons.volume_up),
              //),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => feedbackColor = kColor8);
                      await Future.delayed(Duration(milliseconds: 200)); // brief color delay
                      handleButtonPress("right");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: feedbackColor == kColor8 ? kColor8 : null,
                    ),
                    child: Text("Right"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => feedbackColor = kColor5);
                      await Future.delayed(Duration(milliseconds: 200));
                      handleButtonPress("practice");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: feedbackColor == kColor5 ? kColor5 : null,
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
