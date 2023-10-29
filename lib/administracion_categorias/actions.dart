import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:frontend_2da_parcial/administracion_categorias/model.dart';

class CategoriaDatabaseProvider {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'categorias_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categorias(
            idCategoria INTEGER PRIMARY KEY AUTOINCREMENT,
            descripcion TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertCategoria(Categoria categoria) async {
    final db = await database;
    await db.insert('categorias', categoria.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Categoria>> getAllCategorias() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categorias');
    return List.generate(maps.length, (index) {
      return Categoria.fromJson(maps[index]);
    });
  }

  Future<void> updateCategoria(Categoria categoria) async {
    final db = await database;
    await db.update(
      'categorias',
      categoria.toJson(),
      where: 'idCategoria = ?',
      whereArgs: [categoria.idCategoria],
    );
  }

  Future<void> deleteCategoria(int idCategoria) async {
    final db = await database;
    await db.delete(
      'categorias',
      where: 'idCategoria = ?',
      whereArgs: [idCategoria],
    );
  }
}
