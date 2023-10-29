import 'package:flutter/material.dart';
import 'administracion_categorias/pantalla_principal.dart';
import 'pacientes_doctores/pantalla_principal.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cliente App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClientListScreen(),
    );
  }
}

class ClientListScreen extends StatefulWidget {
  @override
  _ClientListScreenState createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistema de seguimiento de pacientes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return AdministracionCategoriasScreen(); // Navegar a la nueva pantalla
                }));
              },
              child: Text('Administración de categorías'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return AdministracionPacientesDoctoresScreen(); // Navegar a la nueva pantalla
                }));
                // Acción para 'Administración de pacientes y doctores'
              },
              child: Text('Administración de pacientes y doctores'),
            ),
            ElevatedButton(
              onPressed: () {
                // Acción para 'Reserva de turnos'
              },
              child: Text('Reserva de turnos'),
            ),
            ElevatedButton(
              onPressed: () {
                // Acción para 'Ficha clínica'
              },
              child: Text('Ficha clínica'),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //       return AddClientScreen();
      //     }));
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
