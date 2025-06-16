import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';

const Color kColor1 = Color(0xFF44562f);
const Color kColor2 = Color(0xFFb3000c);
const Color kColor3 = Color(0xFFb7c88d);
const Color kColor4 = Color(0xFFe9dfb4);
const Color kColor5 = Color(0xFFefbfb3);
const Color kColor6 = Color(0xFF9f9fd0);
const Color kColor7 = Color(0xFF4b7c9b);
const Color kColor8 = Color(0xFFb1d8e7);

class ConjugationPage extends StatefulWidget {
  @override
  _ConjugationPageState createState() => _ConjugationPageState();
}

class _ConjugationPageState extends State<ConjugationPage> {
  List<dynamic> conjugationList = [];
  dynamic selectedVerb;
  String selectedTense = "present";
  final player = AudioPlayer();

  final Map<String, Map<String, String>> tenseLabels = {
    "past": {"ar": "الماضي", "tr": "al-māḍī", "en": "Past"},
    "present": {"ar": "المضارع", "tr": "al-muḍāriʿ", "en": "Present"},
    "future": {"ar": "المستقبل", "tr": "al-mustaqbal", "en": "Future"},
  };

  @override
  void initState() {
    super.initState();
    loadConjugationData();
  }

  Future<void> loadConjugationData() async {
    final jsonString = await rootBundle.loadString("assets/data/conjugation/conjugation.json");
    final List<dynamic> data = json.decode(jsonString);
    setState(() {
      conjugationList = data;
    });
  }

  void playAudio(String path) async {
    await player.stop();
    await player.play(AssetSource(path.replaceFirst("assets/", "")));
  }

  @override
  Widget build(BuildContext context) {
    final tableStyle = TextStyle(fontSize: 14, color: kColor1, fontFamily: "Lora");

    return Scaffold(
        appBar: AppBar(title: Text("Conjugation")),
        body: Stack(
          children: [
            // === Scrollable main content
            // Added bottom padding to ensure content doesn't hide behind the button
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 80.0), // Added bottom padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === Dropdown and Search
                  DropdownButton<dynamic>(
                    hint: Text("Select a verb"),
                    value: selectedVerb,
                    isExpanded: true,
                    items: conjugationList.map((verb) {
                      final display = "${verb['verb']} | ${verb['translit']} | ${verb['meaning']}";
                      return DropdownMenuItem(
                        value: verb,
                        child: Text(display),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVerb = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),

                  // === Tense Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ["past", "present", "future"].map((tense) {
                      final label = tenseLabels[tense]!;
                      final selected = tense == selectedTense;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selected ? kColor1 : Colors.grey[300],
                          foregroundColor: selected ? Colors.white : kColor2,
                        ),
                        onPressed: () => setState(() => selectedTense = tense),
                        child: Column(
                          children: [
                            Text(label["ar"]!, style: TextStyle(fontSize: 20)),
                            Text(label["tr"]!, style: TextStyle(fontSize: 14, fontFamily: "Lora")),
                            Text(label["en"]!, style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),

                  if (selectedVerb != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // === Verb Header
                        Center(
                          child: Column(
                            children: [
                              Text(
                                selectedVerb['verb'],
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${selectedVerb['translit']} — ${selectedVerb['meaning']}",
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),

                        // === Table of forms
                        ...selectedVerb["forms"][selectedTense].entries.map((entry) {
                          final person = entry.key;
                          final data = entry.value;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              children: [
                                // Person cell
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data["pronoun_ar"] ?? "", style: TextStyle(fontSize: 16)),
                                      Text("${data["pronoun_translit"] ?? ""} | $person", style: tableStyle),
                                    ],
                                  ),
                                ),
                                // Verb cell
                                Expanded(
                                  flex: 5,
                                  child: GestureDetector(
                                    onTap: () => playAudio(data["audio_path"]),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: kColor4,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(data["ar"], style: TextStyle(fontSize: 20, color: kColor2)),
                                          SizedBox(height: 4),
                                          Text(data["tr"], style: tableStyle),
                                          Text(data["en"], style: tableStyle),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                ],
              ),
            ),

            // === Floating Menu Button
            Positioned(
              left: 16,
              right: 16,
              bottom: 20, // Adjust vertical position from bottom
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/'),
                child: Text("Menu"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
            ),
          ],
        ));
  }
}