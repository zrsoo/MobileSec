import 'package:flutter/material.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  void _addCar() {
    String make = _makeController.text.trim();
    String model = _modelController.text.trim();
    String year = _yearController.text.trim();

    if (make.isEmpty || model.isEmpty || year.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    // TODO: Implement API call to add car
    print("🚗 Adding car: Make=$make, Model=$model, Year=$year");

    // Close the screen after adding
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Car")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Make", style: TextStyle(fontSize: 16)),
            TextField(
              controller: _makeController,
              decoration: const InputDecoration(
                hintText: "Enter car make (e.g., Toyota)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Model", style: TextStyle(fontSize: 16)),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(
                hintText: "Enter car model (e.g., Corolla)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Year", style: TextStyle(fontSize: 16)),
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter car year (e.g., 2022)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _addCar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Add Car"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}