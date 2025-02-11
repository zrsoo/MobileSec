import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConfigDatabase {
  static Database? _database;

  // Initialize database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'config.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE theme (id INTEGER PRIMARY KEY, backgroundColor INTEGER)",
        );
      },
    );
  }

  // Get the database instance
  static Future<Database> _getDatabase() async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Save background color with id 1, always replacing
  static Future<void> saveBackgroundColor(int colorValue) async {
    final db = await _getDatabase();
    await db.insert(
      "theme",
      {"id": 1, "backgroundColor": colorValue},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Load background color
  static Future<int?> getBackgroundColor() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query("theme", where: "id = 1");

    if (maps.isNotEmpty) {
      return maps.first["backgroundColor"] as int;
    }
    // Default to system color
    return null;
  }
}
