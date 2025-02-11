import 'package:flutter/material.dart';
import '../services/config_database.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ConfigScreen extends StatefulWidget {
  final Function(Color) onThemeChanged;

  const ConfigScreen({super.key, required this.onThemeChanged});

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  Color _selectedColor = Colors.white; // Default color

  @override
  void initState() {
    super.initState();
    _loadSavedColor();
  }

  // Load saved color from SQLite
  Future<void> _loadSavedColor() async {
    int? savedColor = await ConfigDatabase.getBackgroundColor();
    if (savedColor != null) {
      setState(() {
        _selectedColor = Color(savedColor);
      });
    }
  }

  // Show color picker dialog
  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pick a background color"),
        content: SingleChildScrollView(
          child: MaterialPicker(
            pickerColor: _selectedColor,
            onColorChanged: (Color color) {
              setState(() {
                _selectedColor = color;
              });
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ConfigDatabase.saveBackgroundColor(_selectedColor.value);
              widget.onThemeChanged(_selectedColor);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuration")),
      body: Center(
        child: ElevatedButton(
          onPressed: _pickColor,
          style: ElevatedButton.styleFrom(backgroundColor: _selectedColor),
          child: const Text("Pick Background Color"),
        ),
      ),
    );
  }
}
