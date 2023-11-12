import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';
import 'package:frontend_2da_parcial/reserva_turnos/actions.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/actions.dart';
import 'package:frontend_2da_parcial/reserva_turnos/model.dart';
import 'package:frontend_2da_parcial/reserva_turnos/pantalla_agregar.dart';
import 'package:intl/intl.dart';

class ReservaTurnosScreen extends StatefulWidget {
  set doctorSelect(String doctorSelect) {}

  set pacienteSelect(String pacienteSelect) {}

  @override
  _ReservaTurnosScreenState createState() => _ReservaTurnosScreenState();
}

class _ReservaTurnosScreenState extends State<ReservaTurnosScreen> {
  List<Turno> turnos = [];
  var pacienteSelect = "";
  var doctorSelect = "";
  @override
  void initState() {
    super.initState();
    widget.pacienteSelect = "";
    widget.doctorSelect = "";
    getTurnos();
  }

  Future<void> getTurnos() async {
    final listaTurnos = await TurnoDatabaseProvider().getAllTurnos();
    setState(() {
      turnos = listaTurnos;
    });
  }

  // Función asincrónica para obtener el PacienteDoctor por su ID
    Future<void> obtenerPacientePorId(int idPaciente) async {
      final pacienteDoctor = await PacienteDoctorDatabaseProvider().getPacienteDoctorById(idPaciente);
      setState(() {
        this.pacienteSelect = (pacienteDoctor!.nombre +" "+ pacienteDoctor!.apellido)!;
      });
    }

    // Función asincrónica para obtener el Médico por su ID
    Future<void> obtenerMedicoPorId(int idDoctor) async {
      final medico = await PacienteDoctorDatabaseProvider().getPacienteDoctorById(idDoctor);
      setState(() {
        doctorSelect = (medico!.nombre +" "+ medico!.apellido)!;
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
                obtenerPacientePorId(turno.paciente);
                obtenerMedicoPorId(turno.doctor);
                return ListTile(
                  title: Text(
                      'Paciente: $pacienteSelect'),
                  subtitle:
                      Text('Médico: $doctorSelect Fecha-Hora: ${DateFormat('dd/MM/yyyy').format(turno.fecha)} - ${turno.horario}'),
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
