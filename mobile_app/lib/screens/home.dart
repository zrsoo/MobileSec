import 'package:flutter/material.dart';
import 'package:mobile_app/screens/config.dart';
import '../services/api_service.dart';
import '../widgets/car_card.dart';
import '../models/car.dart';
import 'add_car.dart';

class HomeScreen extends StatefulWidget {
  final Function(Color) onThemeChanged;

  const HomeScreen({super.key, required this.onThemeChanged});

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

  Future<void> _deleteCar(int carId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await ApiService.deleteCar(carId);
      if (success) {
        setState(() {
          _cars.removeWhere((car) => car.id == carId);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Failed to delete car.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  Future<void> _useCar(int carId) async {
    setState(() {
      _isLoading = true;
    });

    int newCondition = _cars.firstWhere((car) => car.id == carId).condition - 10;

    try {
      bool success = await ApiService.updateCar(carId, condition: newCondition);
      if (success) {
        setState(() {
          _cars = _cars.map((car) {
            if (car.id == carId) {
              return Car(id: car.id, brand: car.brand, model: car.model, year: car.year, condition: newCondition);
            }
            return car;
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Failed to update car.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Car List"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfigScreen(onThemeChanged: widget.onThemeChanged),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
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
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Transform.translate(
          offset: const Offset(25, 0),
          child: FloatingActionButton(
            onPressed: () async {
              bool? carAdded = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCarScreen()),
              );

              if (carAdded == true) {
                _fetchCars();
              }
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        ),
      ),
    );
  }
}
