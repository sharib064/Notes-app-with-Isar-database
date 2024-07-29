import 'package:flutter/material.dart';
import 'package:notesapp/models/notes_database.dart';
import 'package:notesapp/pages/notes_page.dart';
import 'package:notesapp/pages/settings_page.dart';
import 'package:notesapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotesDatabase.initialize();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => NotesDatabase(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).getThemeData(),
      home: const NotesPage(),
      routes: {
        '/setting_page': (context) => const SettingsPage(),
      },
    );
  }
}
