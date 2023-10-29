import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'client_model.dart';

class ClientDatabaseProvider {
  ClientDatabaseProvider._();
  
  static final ClientDatabaseProvider db = ClientDatabaseProvider._();
  late Database _database;

  ClientDatabaseProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
            print("SPIERD");

    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "clients.db");
    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE Clients (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT
        )
      ''');
    });
  }

  Future<Database> get database async {
    print("AAAAAAAAAA");
        print("MMMMM");


    await _initDatabase();
            print("AARRRRRRRRRRRRRRAAAAAAAA");

    return _database;
  }

  Future<int> addClientToDatabase(Client client) async {
    final db = await database;
    try {
      return db.insert('Clients', client.toMap());
    } catch (e) {
      print("Error al insertar cliente: $e");
      return -1;
    }
  }

  Future<List<Client>> getAllClients() async {
    print("BRUTAL");
    final db = await database;
        print("RADICAL");

    try {
      final maps = await db.query('Clients');
      return List.generate(maps.length, (index) {
        return Client.fromMap(maps[index]);
      });
    } catch (e) {
      print("Error al obtener clientes: $e");
      return [];
    }
  }
}
