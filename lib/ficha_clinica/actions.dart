import 'package:frontend_2da_parcial/ficha_clinica/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FichaClinicaDatabaseProvider {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path =
        join(await getDatabasesPath(), 'fichas_clinicas_database.db');
    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) {
        db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE fichas_clinicas(
            idFichaClinica INTEGER PRIMARY KEY AUTOINCREMENT,
            fechaDesde TEXT,
            fechaHasta TEXT,
            motivoConsulta TEXT,
            observacion TEXT,
            diagnostico TEXT,
            idDoctor INTEGER,
            idPaciente INTEGER,
            idCategoria INTEGER,
            FOREIGN KEY (idDoctor) REFERENCES personas(idPersona),
            FOREIGN KEY (idPaciente) REFERENCES personas(idPersona),
            FOREIGN KEY (idCategoria) REFERENCES categorias(idCategoria)
          )
        ''');
      },
    );
  }

  Future<void> insertFichaClinica(FichaClinica fichaClinica) async {
    final db = await database;
    await db.insert('fichas_clinicas', fichaClinica.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<FichaClinica>> getAllFichasClinicas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('fichas_clinicas');
    return List.generate(maps.length, (index) {
      return FichaClinica.fromJson(maps[index]);
    });
  }

  Future<void> updateFichaClinica(FichaClinica fichaClinica) async {
    final db = await database;
    await db.update(
      'fichas_clinicas',
      fichaClinica.toJson(),
      where: 'idFichaClinica = ?',
      whereArgs: [fichaClinica.idFichaClinica],
    );
  }

  Future<void> deleteFichaClinica(int idFichaClinica) async {
    final db = await database;
    await db.delete(
      'fichas_clinicas',
      where: 'idFichaClinica = ?',
      whereArgs: [idFichaClinica],
    );
  }
}
