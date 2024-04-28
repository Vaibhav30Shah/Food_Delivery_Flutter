import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'my_database.db';
  static const _tableName = 'restaurant';
  static const List<String> columnNames = [
    'id INTEGER PRIMARY KEY',
    'name TEXT',
    'city TEXT',
    'rating REAL', // Assuming 'rating' is a floating-point number
    'rating_count INTEGER',
    'cost TEXT', // Assuming 'cost' is stored as text
    'cuisine TEXT',
    'lic_no TEXT', // Assuming 'lic_no' is stored as text
    'link TEXT',
    'address TEXT',
    'menu TEXT' // Assuming 'menu' is stored as text
  ];

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
           CREATE TABLE $_tableName (
      ${columnNames.join(', ')}
    )
          ''');
    });
  }

  Future<void> insertFromCSV(String csvFilePath) async {
    Database? db = await instance.database;
    String csvString = await File(csvFilePath).readAsString();
    List<List<dynamic>> csvTable = CsvToListConverter().convert(csvString);

    for (var row in csvTable) {
      Map<String, dynamic> rowData = Map.fromIterables(columnNames, row);
      await db?.insert(_tableName, rowData);
    }
  }
}
