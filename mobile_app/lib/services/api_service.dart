import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:mobile_app/services/storage_service.dart';

class ApiService {
  static const String _baseUrl = "https://192.168.100.12:5000";

  // Custom HTTP client to ignore self-signed certificate errors
  static http.Client _getHttpClient() {
    HttpClient client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(client);
  }

  // Login function
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

  // Register function
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

}
