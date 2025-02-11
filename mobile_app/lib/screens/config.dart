import 'package:flutter/material.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuration")),
      body: const Center(
        child: Text("Theme configuration options will be here.", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
