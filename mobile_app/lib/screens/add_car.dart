import 'package:flutter/material.dart';

import '../services/api_service.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  _AddCarScreenState createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addCar() async {
    String brand = _makeController.text.trim();
    String model = _modelController.text.trim();
    String yearText = _yearController.text.trim();

    if (brand.isEmpty || model.isEmpty || yearText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    int? year = int.tryParse(yearText);
    if (year == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid year!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await ApiService.addCar(brand, model, year);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Car added successfully!")),
        );
        Navigator.pop(context, true); // Return success to refresh home screen
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                onPressed: _isLoading ? null : _addCar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Add Car"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}