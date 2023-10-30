import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/reserva_turnos/actions.dart';
import 'package:frontend_2da_parcial/reserva_turnos/model.dart';
import 'package:frontend_2da_parcial/reserva_turnos/pantalla_agregar.dart';

class ReservaTurnosScreen extends StatefulWidget {
  @override
  _ReservaTurnosScreenState createState() => _ReservaTurnosScreenState();
}

class _ReservaTurnosScreenState extends State<ReservaTurnosScreen> {
  List<Turno> turnos = [];

  @override
  void initState() {
    super.initState();
    getTurnos();
  }

  Future<void> getTurnos() async {
    final listaTurnos = await TurnoDatabaseProvider().getAllTurnos();
    setState(() {
      turnos = listaTurnos;
    });
  }

  // Future<void> insertTurno() async {
  //   final nuevaTurno =
  //       Turno(idTurno: null, descripcion: 'Nueva Categoría');
  //   await TurnoDatabaseProvider().insertTurno(nuevaTurno);
  //   getTurnos();
  // }

  Future<void> updateTurno(Turno Turno) async {
    await TurnoDatabaseProvider().updateTurno(Turno);
    getTurnos();
  }

  Future<void> deleteTurno(int? idTurno) async {
    if (idTurno != null) {
      await TurnoDatabaseProvider().deleteTurno(idTurno);
      getTurnos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserva de Turnos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aquí puedes mostrar la lista de categorías.
            ListView.builder(
              shrinkWrap: true,
              itemCount: turnos.length,
              itemBuilder: (BuildContext context, index) {
                final turno = turnos[index];
                return ListTile(
                  title: Text('Paciente: ${turno.paciente}'),
                  subtitle: Text('Médico: ${turno.doctor}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IconButton(
                      //   icon: Icon(Icons.edit),
                      //   onPressed: () {
                      //     // Obtén la categoría que deseas editar, puedes hacerlo a través de una consulta a la base de datos o como lo necesites.
                      //     final turnoAEditar = Turno(
                      //     idTurno: Turno.idTurno,// asigna el ID de la categoría que deseas editar,
                      //     descripcion: Turno.descripcion,);

                      //     Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      //       return EditarTurnoScreen(Turno: TurnoAEditar); // Pasa la categoría a editar a la pantalla de edición
                      //     }));
                      //   },
                      // ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteTurno(turno.idTurno);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return AgregarTurnoForm();
                }));
              },
              child: Text('Agregar Turno'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(200, 48)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
