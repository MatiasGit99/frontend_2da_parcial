import 'package:frontend_2da_parcial/reserva_turnos/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TurnoDatabaseProvider {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'turnos_database.db');
    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) {
        db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE turnos(
            idTurno INTEGER PRIMARY KEY AUTOINCREMENT,
            idPaciente INTEGER,
            idDoctor INTEGER,
            fecha TEXT,
            horario TEXT,
            paciente_nombre TEXT,
            doctor_nombre TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertTurno(Turno turno) async {
    final db = await database;
    await db.insert('turnos', turno.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Turno>> getAllTurnos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('turnos');
    return List.generate(maps.length, (index) {
      return Turno.fromJson(maps[index]);
    });
  }

  Future<void> updateTurno(Turno turno) async {
    final db = await database;
    await db.update(
      'turnos',
      turno.toJson(),
      where: 'idTurno = ?',
      whereArgs: [turno.idTurno],
    );
  }

  Future<void> deleteTurno(int idTurno) async {
    final db = await database;
    await db.delete(
      'turnos',
      where: 'idTurno = ?',
      whereArgs: [idTurno],
    );
  }
}
