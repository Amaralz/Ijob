import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ijob.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE perfil (
    id TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    cpf TEXT NOT NULL,
    bairro TEXT NOT NULL,
    celular TEXT NOT NULL,
    genero TEXT NOT NULL
    )
''');
  }

  //SALVAR O PERFIL
  Future<int> inserirPerfil(Map<String, dynamic> perfil) async {
    final db = await database;
    return await db.insert('perfil', perfil);
  }

  // BUSCAR O PERFIL
  Future<Map<String, dynamic>?> buscarPerfil(String id) async {
    final db = await database;
    final result = await db.query('perfil', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }
}
