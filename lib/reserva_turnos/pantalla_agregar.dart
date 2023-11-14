import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/actions.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';
import 'package:frontend_2da_parcial/reserva_turnos/actions.dart';
import 'package:frontend_2da_parcial/reserva_turnos/model.dart';
import 'package:frontend_2da_parcial/reserva_turnos/pantalla_principal.dart';
import 'package:intl/intl.dart';

class AgregarTurnoForm extends StatefulWidget {
  @override
  _AgregarTurnoFormState createState() => _AgregarTurnoFormState();
}

class _AgregarTurnoFormState extends State<AgregarTurnoForm> {
  final TextEditingController descripcionController = TextEditingController();
  DateTime fechaSeleccionadaController = DateTime.now(); // Inicializa con la fecha actual
  PacienteDoctor? doctorSeleccionado;
  List<PacienteDoctor> listaDoctores = [];
  PacienteDoctor? pacienteSeleccionado;
  List<PacienteDoctor> listaPacientes = [];
  String? horarioSeleccionado;
  List<String> listaHorarios = [
    '09:00-10:00',
    '10:00-11:00',
    '11:00-12:00',
    '12:00-13:00',
    '13:00-14:00',
    '14:00-15:00',
    '15:00-16:00',
    '16:00-17:00',
    '17:00-18:00',
    '18:00-19:00',
    '19:00-20:00',
    '20:00-21:00'
  ];

  List<Turno> turnos = [];

  @override
  void initState() {
    super.initState();
    cargarMedicosPacientes();
    getTurnos();
  }

  Future<void> getTurnos() async {
    final listaTurnos = await TurnoDatabaseProvider().getAllTurnos();
    setState(() {
      turnos = listaTurnos;
    });
  }

  Future<void> cargarMedicosPacientes() async {
    final doctores = await PacienteDoctorDatabaseProvider().getAllDoctores();
    final pacientes =
        await PacienteDoctorDatabaseProvider().getAllPacientes();
    setState(() {
      listaDoctores = doctores;
      listaPacientes = pacientes;
    });
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionadaController,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (seleccionada != null && seleccionada != fechaSeleccionadaController) {
      setState(() {
        fechaSeleccionadaController = seleccionada;
      });
    }
  }

  Future<void> deleteTurno(int? idTurno) async {
    if (idTurno != null) {
      await TurnoDatabaseProvider().deleteTurno(idTurno);
      getTurnos();
    }
  }

  void limpiarFormulario() {
    setState(() {
      doctorSeleccionado = null;
      pacienteSeleccionado = null;
      horarioSeleccionado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Turno'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<PacienteDoctor>(
              value: doctorSeleccionado,
              onChanged: (PacienteDoctor? newValue) {
                setState(() {
                  doctorSeleccionado = newValue;
                });
              },
              items: listaDoctores.map((PacienteDoctor medico) {
                return DropdownMenuItem<PacienteDoctor>(
                  value: medico,
                  child: Text('${medico.nombre} ${medico.apellido}'),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Médico'),
            ),
            DropdownButtonFormField<PacienteDoctor>(
              value: pacienteSeleccionado,
              onChanged: (PacienteDoctor? newValue) {
                setState(() {
                  pacienteSeleccionado = newValue;
                });
              },
              items: listaPacientes.map((PacienteDoctor paciente) {
                return DropdownMenuItem<PacienteDoctor>(
                  value: paciente,
                  child: Text('${paciente.nombre} ${paciente.apellido}'),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Paciente'),
            ),
            Row(
              children: [
                Text('Fecha: '),
                Text(DateFormat('dd/MM/yyyy')
                    .format(fechaSeleccionadaController)),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _seleccionarFecha(context),
                  child: Text('Seleccionar Fecha'),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: horarioSeleccionado,
              onChanged: (String? newValue) {
                setState(() {
                  horarioSeleccionado = newValue;
                });
              },
              items: listaHorarios.map((String horario) {
                return DropdownMenuItem<String>(
                  value: horario,
                  child: Text(horario),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Horario'),
            ),
            ElevatedButton(
              onPressed: () {
                // Guardar la nueva reserva en la base de datos.
                int paciente = pacienteSeleccionado!.idPersona!;
                String paciente_nombre = pacienteSeleccionado!.nombre!;
                int doctor = doctorSeleccionado!.idPersona!;
                String doctor_nombre = doctorSeleccionado!.nombre!;
                var horario = horarioSeleccionado!.toString();
                final nuevoTurno = Turno(
                  paciente: paciente,
                  doctor: doctor,
                  fecha: fechaSeleccionadaController,
                  horario: horario,
                  paciente_nombre: paciente_nombre,
                  doctor_nombre: doctor_nombre,
                );
                TurnoDatabaseProvider().insertTurno(nuevoTurno);

                // Después de la inserción, actualiza la lista de turnos y limpia el formulario
                getTurnos();
                limpiarFormulario();
              },
              child: Text('Guardar Turno'),
            ),
            SizedBox(height: 20),
            Text(
              'Reservas realizadas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: turnos.length,
                itemBuilder: (BuildContext context, index) {
                  final turno = turnos[index];
                  return ListTile(
                    title: Text('Paciente: ${turno.paciente_nombre}'),
                    subtitle: Text(
                      'Médico: ${turno.doctor_nombre} Fecha-Hora: ${DateFormat('dd/MM/yyyy').format(turno.fecha)} - ${turno.horario}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Call the method to delete the selected reservation
                        deleteTurno(turno.idTurno);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
