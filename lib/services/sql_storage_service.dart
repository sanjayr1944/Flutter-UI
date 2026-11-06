import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        //name
        //email
        //age
        //-------------------------- Creating Table ---------------------------------
        await db.execute('''
        CREATE TABLE students
        (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        age INTEGER 
        )
        ''');
      },
    );
  }

  //INSERT
  Future<int> insertStudent(Map<String, dynamic> student) async {
    Database db = await database;
    return await db.insert(
      'student',
      student,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //READ

  Future<List<Map<String, dynamic>>> getAllStudents() async {
    Database db = await database;
    return await db.query('students'); //SELECT * FROM students
  }
  //UPDATE

  Future<int> updateStudent(int id, Map<String, dynamic> student) async {
    Database db = await database;
    return await db.update(
      'students',
      student,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  //DELETE

  Future<int> deleteStudent(int id) async {
    Database db = await database;

    return await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }
}
