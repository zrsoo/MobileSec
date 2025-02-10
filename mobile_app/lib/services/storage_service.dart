import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Save JWT token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: "jwt_token", value: token);
  }

  // Retrieve JWT token
  static Future<String?> getToken() async {
    return await _storage.read(key: "jwt_token");
  }

  // Delete JWT token (for logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: "jwt_token");
  }
}
