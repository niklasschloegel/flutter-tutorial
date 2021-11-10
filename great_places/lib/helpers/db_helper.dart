import 'package:great_places/models/place.dart';
import "package:sqflite/sqflite.dart" as sql;
import "package:path/path.dart" as path;
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, "places.db"),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE user_places(${Place.ID_KEY} TEXT PRIMARY_KEY, ${Place.TITLE_KEY} TEXT, ${Place.IMAGE_PATH_KEY} TEXT, ${Place.LOC_LAT_KEY} REAL, ${Place.LOC_LNG_KEY} REAL, ${Place.ADDRESS_KEY} TEXT)");
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await database();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, Object?>>> getData(String table) async {
    final db = await database();
    return db.query(table);
  }
}
