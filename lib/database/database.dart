import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance =
      DatabaseService._internal();

  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(
      await getDatabasesPath(),
      'inventory.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE boxes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        started_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        box_id INTEGER NOT NULL,
        name TEXT,
        ocr_text TEXT,
        thumbnail TEXT,
        confidence REAL,
        added_at TEXT,
        FOREIGN KEY(box_id)
          REFERENCES boxes(id)
      )
    ''');
  }

  Future<int> createBox() async {
    final db = await database;

    return await db.insert(
      'boxes',
      {
        'started_at':
            DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>>
      getBoxes() async {
    final db = await database;

    return await db.query(
      'boxes',
      orderBy: 'id DESC',
    );
  }

  Future<void> insertItem({
    required int boxId,
    required String name,
    required String ocrText,
    required String thumbnail,
    required double confidence,
  }) async {
    final db = await database;

    await db.insert(
      'items',
      {
        'box_id': boxId,
        'name': name,
        'ocr_text': ocrText,
        'thumbnail': thumbnail,
        'confidence': confidence,
        'added_at':
            DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>>
      getItems(int boxId) async {
    final db = await database;

    return await db.query(
      'items',
      where: 'box_id = ?',
      whereArgs: [boxId],
    );
  }
}