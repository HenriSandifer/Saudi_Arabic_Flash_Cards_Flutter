import 'package:flutter/material.dart';
import 'new_new_flashcard_page.dart';
import 'new_conjugation_page.dart';

const Color kColor1 = Color(0xFF44562f);
const Color kColor2 = Color(0xFFb3000c);
const Color kColor3 = Color(0xFFb7c88d);
const Color kColor4 = Color(0xFFe9dfb4);
const Color kColor5 = Color(0xFFefbfb3);
const Color kColor6 = Color(0xFF9f9fd0);
const Color kColor8 = Color(0xFFb1d8e7);
const Color kColor9 = Color(0xFF1f224d);

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Rawa',
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: kColor1,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: kColor1,
        secondary: kColor2,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: kColor9),
        bodyLarge: TextStyle(color: kColor9),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kColor4,
          foregroundColor: kColor9,
          textStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 32,
            fontFamily: "Norwester"),
        ),
      ),
    ),

    initialRoute: '/',
    routes: {
      '/': (context) => MenuScreen(),
      '/flashcards': (context) => FlashcardPage(),
      '/conjugation': (context) => ConjugationPage(),
    },
  ));
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rawa",
          style: TextStyle(
            fontFamily: 'Norwester',
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Spacer(flex: 2), // Pushes logo slightly down from the top
          Center(
            child: Image.asset(
              'assets/visuals/rawa_logo.png',
              width: 150,
              height: 150,
            ),
          ),
          const Spacer(flex: 3), // Creates vertical space between logo and buttons
          Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/flashcards'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    minimumSize: Size(200, 60),
                  ),
                  child: Text(
                    "Flash Cards",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/conjugation'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    minimumSize: Size(200, 60),
                  ),
                  child: Text(
                    "Conjugation",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 2), // Optional: pushes everything up a bit
        ],
      ),
    );
  }
}

