import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_example/note_model.dart';

class DatabaseHelper {

  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    log('DB INITIALIZED');
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    log('DB OPENED');
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE note (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL
          )
          ''');
  }

  Future<int> createNote(Note note) async {
    Database db = await instance.database;
    return await db.rawInsert('INSERT INTO note(title, content) VALUES("${note.title}", "${note.content}")');
  }

  Future<List<Note>> getAllNote() async {
    Database db = await instance.database;
    final data =  await db.rawQuery('SELECT * FROM note');
    log(data.toString());
    return data.map((e) => Note.fromMap(e)).toList();
  }

  Future<dynamic> getById({required int id}) async {
    Database db = await instance.database;
    return db.rawQuery('SELECT * FROM NOTE WHERE _id = $id');
  }

  Future<int> update(Note note) async {
    Database db = await instance.database;
    return await db.rawUpdate('UPDATE note SET title = ?, content = ? WHERE _id = ?',
      [note.title, note.content, note.id]
    );
  }

  Future<int> delete({required int id}) async {
    Database db = await instance.database;
    return await db.rawDelete('DELETE FROM NOTE WHERE _id = $id');
  }
}