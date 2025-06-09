import 'package:flutter/material.dart';
import 'new_new_flashcard_page.dart';
import 'conjugation_page.dart';

const Color kColor1 = Color(0xFF44562f);
const Color kColor2 = Color(0xFFb3000c);
const Color kColor3 = Color(0xFFb7c88d);
const Color kColor4 = Color(0xFFe9dfb4);
const Color kColor5 = Color(0xFFefbfb3);
const Color kColor6 = Color(0xFF9f9fd0);
const Color kColor8 = Color(0xFFb1d8e7);


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Saudi Arabic App',
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: kColor1,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: kColor1,
        secondary: kColor2,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: kColor1),
        bodyLarge: TextStyle(color: kColor1),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kColor4,
          foregroundColor: kColor1,
          textStyle: TextStyle(fontWeight: FontWeight.bold),
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
      appBar: AppBar(title: Text("Saudi Arabic App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Flash Cards"),
              onPressed: () => Navigator.pushNamed(context, '/flashcards'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Conjugation"),
              onPressed: () => Navigator.pushNamed(context, '/conjugation'),
            ),
          ],
        ),
      ),
    );
  }
}
