import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';
import 'package:frontend_2da_parcial/reserva_turnos/actions.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/actions.dart';
import 'package:frontend_2da_parcial/reserva_turnos/model.dart';
import 'package:frontend_2da_parcial/reserva_turnos/pantalla_agregar.dart';
import 'package:frontend_2da_parcial/reserva_turnos/pantalla_editar.dart';
import 'package:intl/intl.dart';

class ReservaTurnosScreen extends StatefulWidget {
  set doctorSelect(String doctorSelect) {}

  set pacienteSelect(String pacienteSelect) {}

  @override
  _ReservaTurnosScreenState createState() => _ReservaTurnosScreenState();
}

class _ReservaTurnosScreenState extends State<ReservaTurnosScreen> {
  List<Turno> turnos = [];
  List<PacienteDoctor> pacientesDoctores = [];
  List<Turno> turnosFiltrados = [];
  String selectedFilter = 'Doctor';
  var pacienteSelect = "";
  var doctorSelect = "";
  @override
  void initState() {
    super.initState();
    widget.pacienteSelect = "";
    widget.doctorSelect = "";
    getTurnos();
    getPacienteDoctor();
  }

  Future<void> getTurnos() async {
    final listaTurnos = await TurnoDatabaseProvider().getAllTurnos();
    setState(() {
      turnos = listaTurnos;
      turnosFiltrados = listaTurnos;
    });
  }

  Future<void> getPacienteDoctor() async {
    final listaPacienteDoctor =
        await PacienteDoctorDatabaseProvider().getAllPacientesDoctores();
    setState(() {
      pacientesDoctores = listaPacienteDoctor;
    });
  }

// Función para obtener el PacienteDoctor por su ID
  void obtenerPacientePorId(int idPaciente) {
    PacienteDoctorDatabaseProvider()
        .getPacienteDoctorById(idPaciente)
        .then((pacienteDoctor) {
      setState(() {
        this.pacienteSelect =
            (pacienteDoctor!.nombre + " " + pacienteDoctor!.apellido)!;
      });
    });
  }

// Función para obtener el Médico por su ID
  void obtenerMedicoPorId(int idDoctor) {
    PacienteDoctorDatabaseProvider()
        .getPacienteDoctorById(idDoctor)
        .then((medico) {
      setState(() {
        doctorSelect = (medico!.nombre + " " + medico!.apellido)!;
      });
    });
  }

  // Función asincrónica para obtener el PacienteDoctor por su ID
  // Future<void> obtenerPacientePorId(int idPaciente) async {
  //   final pacienteDoctor = await PacienteDoctorDatabaseProvider()
  //       .getPacienteDoctorById(idPaciente);
  //   setState(() {
  //     this.pacienteSelect =
  //         (pacienteDoctor!.nombre + " " + pacienteDoctor!.apellido)!;
  //   });
  // }

  // // Función asincrónica para obtener el Médico por su ID
  // Future<void> obtenerMedicoPorId(int idDoctor) async {
  //   final medico =
  //       await PacienteDoctorDatabaseProvider().getPacienteDoctorById(idDoctor);
  //   setState(() {
  //     doctorSelect = (medico!.nombre + " " + medico!.apellido)!;
  //   });
  // }

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

  void filterCategorias(String searchText) {
    setState(() {
      turnosFiltrados = turnos.where((turnos) {
        // if (mostrarSoloDoctores && pacientesDoctores.flagEsDoctor != 1) {
        //   return false;
        // }

        if (selectedFilter == 'Doctor') {
          // Encuentra todos los PacienteDoctor cuyo nombre contiene searchText
          List<int?> idsEncontrados = pacientesDoctores
              .where((pacienteDoctor) => pacienteDoctor.nombre
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
              .map((pacienteEncontrado) => pacienteEncontrado.idPersona)
              .toList();
          // Verifica si al menos uno de los IDs está presente en turnos.paciente
          if (idsEncontrados.length == 1) {
            return idsEncontrados.contains(turnos.doctor);
          } else {
            return idsEncontrados.any((id) => id == turnos.doctor);
          }
        } else {
          return turnos.idTurno != null;
        }
      }).toList();
    });
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
            Row(
              children: [
                Text('Filtrar por:'),
                DropdownButton<String>(
                  value: selectedFilter,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedFilter = newValue;
                      });
                    }
                  },
                  items: <String>['Doctor', 'Paciente']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                // SizedBox(width: 16), // Espaciado para separar los elementos
                // Checkbox(
                //   value: mostrarSoloDoctores,
                //   onChanged: (value) {
                //     setState(() {
                //       mostrarSoloDoctores = value!;
                //       filterCategorias('');
                //     });
                //   },
                // ),
                // Text('Mostrar solo Doctores'),
              ],
            ),
            TextField(
              onChanged: (value) {
                filterCategorias(value);
              },
              decoration: InputDecoration(labelText: 'Buscar'),
            ),

            // Aquí puedes mostrar la lista de categorías.
            ListView.builder(
              shrinkWrap: true,
              itemCount: turnosFiltrados.length,
              itemBuilder: (BuildContext context, index) {
                final turno = turnosFiltrados[index]; 
                // obtenerPacientePorId(turno.paciente);
                // obtenerMedicoPorId(turno.doctor);
                return ListTile(
                  title: Text('Paciente: ${turno.paciente_nombre}'),
                  subtitle: Text(
                      'Médico: ${turno.doctor_nombre} Fecha-Hora: ${DateFormat('dd/MM/yyyy').format(turno.fecha)} - ${turno.horario}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Obtén la categoría que deseas editar, puedes hacerlo a través de una consulta a la base de datos o como lo necesites.
                          // final turnoAEditar = Turno(
                          // idTurno: categoria.idCategoria,// asigna el ID de la categoría que deseas editar,
                          // descripcion: categoria.descripcion,);

                          // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                          //   return EditarTurnoScreen(turno: turno); // Pasa el turno a editar a la pantalla de edición
                          // }));
                        },
                      ),
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
          ],
        ),
      ),
    );
  }
}
