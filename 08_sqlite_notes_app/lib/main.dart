import 'package:flutter/material.dart';
import 'views/notes_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NotesApp(),
  ));
}


/// Udemy Course - Sections 15 & 16: SQLite Local Database Notes App
class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotesListScreen();
  }
}