import 'package:flutter/material.dart';
import 'package:mobile_app/screens/login.dart';
import 'package:mobile_app/services/config_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved color from SQLite
  int? savedColor = await ConfigDatabase.getBackgroundColor();

  runApp(MyApp(initialColor: savedColor != null ? Color(savedColor) : Colors.white));
}

class MyApp extends StatefulWidget {
  final Color initialColor;

  const MyApp({super.key, required this.initialColor});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _backgroundColor = widget.initialColor; // Set initial theme color
  }

  void _updateTheme(Color newColor) async {
    setState(() {
      _backgroundColor = newColor; // Update global theme
    });

    await ConfigDatabase.saveBackgroundColor(newColor.value); // Save to SQLite
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _backgroundColor, // Apply background color globally
      ),
      home: LoginScreen(onThemeChanged: _updateTheme),
    );
  }
}
