import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Database? _database;
  static const int _databaseVersion = 3;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // ========================================
  // FIRESTORE
  // ========================================

  Future<Map<String, dynamic>?> getPerfil(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Erro ao buscar perfil (Firestore): $e');
      return null;
    }
  }

  Future<void> atualizarPerfil(String uid, Map<String, dynamic> dados) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .set(dados, SetOptions(merge: true));
    } catch (e) {
      print('Erro ao atualizar perfil (Firestore): $e');
      rethrow;
    }
  }

  // ========================================
  // SQLITE
  // ========================================

  Future<bool> cpfExiste(String cpf) async {
    final db = await database;
    final result = await db.query('perfil', where: 'cpf = ?', whereArgs: [cpf]);
    return result.isNotEmpty;
  }

  Future<bool> celularExiste(String celular) async {
    final db = await database;
    final result = await db.query(
      'perfil',
      where: 'celular = ?',
      whereArgs: [celular],
    );
    return result.isNotEmpty;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ijob.db');
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE perfil (
        id TEXT PRIMARY KEY,
        nome TEXT,
        cpf TEXT,
        rua TEXT,
        numero TEXT,
        bairro TEXT,
        cidade TEXT,
        estado TEXT,
        pais TEXT,
        celular TEXT,
        genero TEXT,
        role TEXT
      )
    ''');
  }

  // MIGRATION SEGURA: SÓ ADICIONA SE NÃO EXISTIR
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await _addColumnIfNotExists(db, 'perfil', 'rua', 'TEXT');
      await _addColumnIfNotExists(db, 'perfil', 'numero', 'TEXT');
      await _addColumnIfNotExists(db, 'perfil', 'bairro', 'TEXT');
      await _addColumnIfNotExists(db, 'perfil', 'cidade', 'TEXT');
      await _addColumnIfNotExists(db, 'perfil', 'estado', 'TEXT');
      await _addColumnIfNotExists(db, 'perfil', 'pais', 'TEXT');
      await _addColumnIfNotExists(db, 'perfil', 'celular', 'TEXT');
      await _addColumnIfNotExists(db, 'perfil', 'genero', 'TEXT');
      await _addColumnIfNotExists(db, 'perfil', 'role', 'TEXT');
    }
  }

  Future<void> _addColumnIfNotExists(
    Database db,
    String table,
    String column,
    String type,
  ) async {
    final columns = await db.rawQuery('PRAGMA table_info($table)');
    final exists = columns.any((col) => col['name'] == column);
    if (!exists) {
      await db.execute('ALTER TABLE $table ADD COLUMN $column $type');
    }
  }

  // ========================================
  // CRUD LOCAL
  // ========================================

  Future<int> inserirPerfil(Map<String, dynamic> perfil) async {
    final db = await database;
    return await db.insert(
      'perfil',
      perfil,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> buscarPerfil(String id) async {
    final db = await database;
    final result = await db.query('perfil', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // ========================================
  // Deletar do banco local
  // ========================================

  Future<void> deletarPerfil(String uid) async {
    final db = await database;
    await db.delete('perfil', where: 'id = ?', whereArgs: [uid]);
  }
}
