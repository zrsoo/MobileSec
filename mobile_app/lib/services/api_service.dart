import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:mobile_app/services/storage_service.dart';

import '../models/car.dart';

class ApiService {
  static const String _baseUrl = "https://192.168.100.12:5000";

  // Custom HTTP client to ignore self-signed certificate errors
  static http.Client _getHttpClient() {
    HttpClient client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(client);
  }

  // Login
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final Uri url = Uri.parse("$_baseUrl/auth/login");

    try {
      final response = await _getHttpClient().post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException("Connection timed out");
      });

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save token if request is successful
        await StorageService.saveToken(responseData["token"]);
        return {"success": true, "token": responseData["token"]};
      } else {
        return {"success": false, "error": responseData["error"] ?? "Login failed"};
      }
    }
    catch (e) {
      if (e is TimeoutException) {
        return {"success": false, "error": "Request timed out. Please check your internet connection."};
      }
      return {"success": false, "error": "Failed to connect to the server"};
    }
  }

  // Register
  static Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final Uri url = Uri.parse("$_baseUrl/auth/register");

    try {
      final response = await _getHttpClient()
          .post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "email": email, "password": password}),
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException("Connection timed out. Please try again.");
      });

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {"success": true};
      } else {
        return {"success": false, "error": responseData["error"] ?? "Registration failed"};
      }
    } catch (e) {
      if (e is TimeoutException) {
        return {"success": false, "error": "Request timed out. Please check your internet connection."};
      }
      return {"success": false, "error": "Failed to connect to the server."};
    }
  }

  // Fetch cars
  static Future<List<Car>> getCars() async {
    final Uri url = Uri.parse("$_baseUrl/cars");

    try {
      final response = await _getHttpClient().get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException("Request timed out.");
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> carsList = jsonDecode(response.body);
        return carsList.map((json) => Car.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch cars. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch cars: $e");
    }
  }

  // Delete car by id
  static Future<bool> deleteCar(int carId) async {
    final Uri url = Uri.parse("$_baseUrl/cars/$carId");

    try {
      final response = await _getHttpClient().delete(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException("Request timed out.");
        },
      );

      if (response.statusCode == 200) {
        return true; // Car deleted successfully
      } else {
        throw Exception("Failed to delete car. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to delete car: $e");
    }
  }

  // Update car
  static Future<bool> updateCar(int carId, {String? brand, String? model, int? year, int? condition}) async {
    final Uri url = Uri.parse("$_baseUrl/cars/$carId");

    // Create the body with only the fields that are updated
    Map<String, dynamic> updatedFields = {};
    if (brand != null) updatedFields["brand"] = brand;
    if (model != null) updatedFields["model"] = model;
    if (year != null) updatedFields["year"] = year;
    if (condition != null) updatedFields["condition"] = condition;

    try {
      final response = await _getHttpClient().put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedFields),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException("Request timed out.");
        },
      );

      if (response.statusCode == 200) {
        return true; // Update successful
      } else {
        throw Exception("Failed to update car. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to update car: $e");
    }
  }

  // Add car
  static Future<bool> addCar(String brand, String model, int year) async {
    final Uri url = Uri.parse("$_baseUrl/cars");

    final Map<String, dynamic> carData = {
      "brand": brand,
      "model": model,
      "year": year,
    };

    try {
      final response = await _getHttpClient().post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(carData),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException("Request timed out.");
        },
      );

      if (response.statusCode == 201) {
        return true; // Car added successfully
      } else {
        throw Exception("Failed to add car. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to add car: $e");
    }
  }
}
