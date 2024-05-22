import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/event.dart';
import '../model/event_subscription.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;
  static const int _databaseVersion = 3;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'events_database.db');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        created_at TEXT,
        updated_at TEXT
      )
      ''');
    await db.execute('''
      CREATE TABLE event_subscription (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        event_id INTEGER,
        aluno TEXT,
        token TEXT,
        presence INTEGER DEFAULT 0,
        created_at TEXT,
        updated_at TEXT,
        FOREIGN KEY (event_id) REFERENCES events (id) ON DELETE CASCADE
      )
      ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('oldVersion: ${oldVersion}');
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE event_subscription (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          event_id INTEGER,
          aluno TEXT,
          token TEXT,
          presence INTEGER DEFAULT 0,
          created_at TEXT,
          updated_at TEXT,
          FOREIGN KEY (event_id) REFERENCES events (id) ON DELETE CASCADE
        )
        ''');
    } else if (oldVersion == 2) {
      await db.execute('ALTER TABLE event_subscription ADD COLUMN token TEXT');
    }
  }

  Future<int> insertEvent(Event event) async {
    final db = await database;
    return await db.insert('events', event.toMap());
  }

  Future<int> insertEventSubscription(
      EventSubscription eventSubscription) async {
    final db = await database;
    return await db.insert('event_subscription', eventSubscription.toMap());
  }

  Future<List<Event>> getEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('events');

    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

  Future<List<EventSubscription>> getEventSubscriptions(int eventId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'event_subscription',
      where: 'event_id = ?',
      whereArgs: [eventId],
    );

    return List.generate(maps.length, (i) {
      return EventSubscription.fromMap(maps[i]);
    });
  }
}
