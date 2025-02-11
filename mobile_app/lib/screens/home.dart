import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/car_card.dart';
import '../models/car.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Car> _cars = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  // Fetch cars from API
  Future<void> _fetchCars() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<Car> cars = await ApiService.getCars();
      setState(() {
        _cars = cars;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load cars.";
        _isLoading = false;
      });
    }
  }

  // Placeholder delete function
  void _deleteCar(int carId) {
    print("Delete car with ID: $carId");
  }

  // Placeholder use function
  void _useCar(int carId) {
    print("Use car with ID: $carId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Car List"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : ListView.builder(
        itemCount: _cars.length,
        itemBuilder: (context, index) {
          final car = _cars[index];
          return CarCard(
            car: car,
            onDelete: () => _deleteCar(car.id),
            onUse: () => _useCar(car.id),
          );
        },
      ),
    );
  }
}
