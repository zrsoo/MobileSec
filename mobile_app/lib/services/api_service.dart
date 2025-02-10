import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

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
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {"success": true, "token": responseData["token"]};
      } else {
        return {"success": false, "error": responseData["error"] ?? "Login failed"};
      }
    } catch (e) {
      return {"success": false, "error": "Failed to connect to the server"};
    }
  }
}
