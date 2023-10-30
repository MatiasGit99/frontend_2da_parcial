import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';

class PacienteDoctorDatabaseProvider {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path =
        join(await getDatabasesPath(), 'pacientes_doctores_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
    CREATE TABLE pacientes_doctores(
      idPersona INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT,
      apellido TEXT,
      telefono TEXT,
      email TEXT,
      cedula TEXT,
      flagEsDoctor INTEGER
    )
  ''');
      },
    );
  }

  Future<List<PacienteDoctor>> getAllDoctores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('pacientes_doctores', where: 'flagEsDoctor = ?', whereArgs:[1]);
    return List.generate(maps.length, (index) {
      return PacienteDoctor.fromJson(maps[index]);
    });
  }

  Future<List<PacienteDoctor>> getAllPacientes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('pacientes_doctores', where: 'flagEsDoctor = ?', whereArgs:[0]);
    return List.generate(maps.length, (index) {
      return PacienteDoctor.fromJson(maps[index]);
    });
  }

  Future<void> insertPacienteDoctor(PacienteDoctor pacienteDoctor) async {
    final db = await database;
    print("NONONON");
    print(pacienteDoctor.idPersona);
    await db.insert('pacientes_doctores', pacienteDoctor.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PacienteDoctor>> getAllPacientesDoctores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('pacientes_doctores');
    return List.generate(maps.length, (index) {
      return PacienteDoctor.fromJson(maps[index]);
    });
  }

  Future<void> updatePacienteDoctor(PacienteDoctor pacienteDoctor) async {
    final db = await database;
    await db.update(
      'pacientes_doctores',
      pacienteDoctor.toJson(),
      where: 'idPersona = ?',
      whereArgs: [pacienteDoctor.idPersona],
    );
  }

  Future<void> deletePacienteDoctor(int idPersona) async {
    final db = await database;
    await db.delete(
      'pacientes_doctores',
      where: 'idPersona = ?',
      whereArgs: [idPersona],
    );
  }
}
