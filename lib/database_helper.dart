import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fizheat.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        teacher TEXT NOT NULL,
        student TEXT NOT NULL,
        description TEXT NOT NULL,
        fileName TEXT,
        filePath TEXT,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // Регистрация пользователя
  Future<bool> registerUser({
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final db = await database;

      final existing = await db.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (existing.isNotEmpty) {
        return false;
      }

      await db.insert('users', {
        'username': username,
        'email': email,
        'password': password,
        'role': role,
      });
      return true;
    } catch (e) {
      print('Ошибка регистрации: $e');
      return false;
    }
  }

  // Вход пользователя
  Future<Map<String, dynamic>?> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      final db = await database;

      final result = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    } catch (e) {
      print('Ошибка входа: $e');
      return null;
    }
  }

  // Получить всех пользователей
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Получить всех учеников (role = 'Ученик')
  Future<List<Map<String, dynamic>>> getStudents() async {
    try {
      final db = await database;
      return await db.query(
        'users',
        where: 'role = ?',
        whereArgs: ['Ученик'],
        orderBy: 'username ASC',
      );
    } catch (e) {
      print('Ошибка получения учеников: $e');
      return [];
    }
  }

  // Проверить существует ли пользователь
  Future<bool> userExists(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  // Вставить пользователя
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  // Добавить задание
  Future<int> addTask({
    required String teacher,
    required String student,
    required String description,
    required String fileName,
    required String filePath,
  }) async {
    try {
      final db = await database;
      return await db.insert('tasks', {
        'teacher': teacher,
        'student': student,
        'description': description,
        'fileName': fileName,
        'filePath': filePath,
      });
    } catch (e) {
      print('Ошибка добавления задания: $e');
      return -1;
    }
  }

  // Получить задания ученика
  Future<List<Map<String, dynamic>>> getStudentTasks(String student) async {
    try {
      final db = await database;
      return await db.query(
        'tasks',
        where: 'student = ?',
        whereArgs: [student],
        orderBy: 'createdAt DESC',
      );
    } catch (e) {
      print('Ошибка получения заданий: $e');
      return [];
    }
  }

  // Получить задания учителя
  Future<List<Map<String, dynamic>>> getTeacherTasks(String teacher) async {
    try {
      final db = await database;
      return await db.query(
        'tasks',
        where: 'teacher = ?',
        whereArgs: [teacher],
        orderBy: 'createdAt DESC',
      );
    } catch (e) {
      print('Ошибка получения заданий: $e');
      return [];
    }
  }

  // Удалить задание
  Future<int> deleteTask(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Ошибка удаления задания: $e');
      return -1;
    }
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
