import 'package:flutter/material.dart';
import 'flashcard_page.dart';
import 'conjugation_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Saudi Arabic App',
    theme: ThemeData(primarySwatch: Colors.teal),
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
