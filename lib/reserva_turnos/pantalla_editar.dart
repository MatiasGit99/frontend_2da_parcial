// import 'package:flutter/material.dart';
// import 'package:frontend_2da_parcial/pacientes_doctores/actions.dart';
// import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';
// import 'package:frontend_2da_parcial/reserva_turnos/actions.dart';
// import 'package:frontend_2da_parcial/reserva_turnos/model.dart';
// import 'package:frontend_2da_parcial/reserva_turnos/pantalla_principal.dart';
// import 'package:intl/intl.dart';

// class EditarTurnoScreen extends StatefulWidget {
//   final Turno turno;

//   EditarTurnoScreen({required this.turno});

//   @override
//   _EditarTurnoScreenState createState() => _EditarTurnoScreenState();
// }

// class _EditarTurnoScreenState extends State<EditarTurnoScreen> {
//   late DateTime fechaSeleccionadaController; // Inicializa con la fecha actual
//   PacienteDoctor? doctorSeleccionado = new PacienteDoctor(
//       idPersona: 0,
//       nombre: '',
//       apellido: '',
//       telefono: '',
//       email: '',
//       cedula: '',
//       flagEsDoctor: 0);
//   List<PacienteDoctor> listaDoctores = [];
//   PacienteDoctor? pacienteSeleccionado = new PacienteDoctor(
//       idPersona: 0,
//       nombre: '',
//       apellido: '',
//       telefono: '',
//       email: '',
//       cedula: '',
//       flagEsDoctor: 0);
//   List<PacienteDoctor> listaPacientes = [];
//   String? horarioSeleccionado;
//   List<String> listaHorarios = [
//     '09:00-10:00',
//     '10:00-11:00',
//     '11:00-12:00',
//     '12:00-13:00',
//     '13:00-14:00',
//     '14:00-15:00',
//     '15:00-16:00',
//     '16:00-17:00',
//     '17:00-18:00',
//     '18:00-19:00',
//     '19:00-20:00',
//     '20:00-21:00'
//   ];

//   @override
//   void initState() {
//     super.initState();
//     obtenerMedicoPorId(widget.turno.doctor);
//     obtenerPacientePorId(widget.turno.paciente);
//     fechaSeleccionadaController = widget.turno.fecha;
//     horarioSeleccionado = widget.turno.horario;
//     cargarMedicosPacientes();
//   }

//   Future<void> cargarMedicosPacientes() async {
//     final doctores = await PacienteDoctorDatabaseProvider().getAllDoctores();
//     final pacientes = await PacienteDoctorDatabaseProvider().getAllPacientes();
//     setState(() {
//       listaDoctores = doctores;
//       listaPacientes = pacientes;
//     });
//   }

//   Future<void> _seleccionarFecha(BuildContext context) async {
//     final seleccionada = await showDatePicker(
//       context: context,
//       initialDate: fechaSeleccionadaController,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );

//     if (seleccionada != null && seleccionada != fechaSeleccionadaController) {
//       setState(() {
//         fechaSeleccionadaController = seleccionada;
//       });
//     }
//   }

//   // Función asincrónica para obtener el PacienteDoctor por su ID
//   Future<void> obtenerPacientePorId(int idPaciente) async {
//     final pacienteDoctor = await PacienteDoctorDatabaseProvider()
//         .getPacienteDoctorById(idPaciente);
//     setState(() {
//       pacienteSeleccionado = pacienteDoctor;
//     });
//   }

//   // Función asincrónica para obtener el Médico por su ID
//   Future<void> obtenerMedicoPorId(int idDoctor) async {
//     final medico =
//         await PacienteDoctorDatabaseProvider().getPacienteDoctorById(idDoctor);
//     setState(() {
//       doctorSeleccionado = medico;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Agregar Turno'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             DropdownButtonFormField<int>(
//               value: doctorSeleccionado
//                   ?.idPersona, // Usa el idPersona como valor único
//               onChanged: (int? newValue) {
//                 if (newValue != null) {
//                   setState(() {
//                     doctorSeleccionado = listaDoctores
//                         .firstWhere((medico) => medico.idPersona == newValue);
//                   });
//                 }
//               },
//               items: listaDoctores.map((PacienteDoctor medico) {
//                 return DropdownMenuItem<int>(
//                   value: medico.idPersona,
//                   child: Text('${medico.nombre} ${medico.apellido}'),
//                 );
//               }).toList(),
//               decoration: InputDecoration(labelText: 'Médico'),
//             ),
//             DropdownButtonFormField<int>(
//               value: pacienteSeleccionado
//                   ?.idPersona, // Usa el idPersona como valor único
//               onChanged: (int? newValue) {
//                 if (newValue != null) {
//                   setState(() {
//                     pacienteSeleccionado = listaPacientes.firstWhere(
//                         (paciente) => paciente.idPersona == newValue);
//                   });
//                 }
//               },
//               items: listaPacientes.map((PacienteDoctor paciente) {
//                 return DropdownMenuItem<int>(
//                   value: paciente.idPersona,
//                   child: Text('${paciente.nombre} ${paciente.apellido}'),
//                 );
//               }).toList(),
//               decoration: InputDecoration(labelText: 'Paciente'),
//             ),
//             Row(
//               children: [
//                 Text('Fecha: '),
//                 Text(DateFormat('dd/MM/yyyy')
//                     .format(fechaSeleccionadaController)),
//                 SizedBox(width: 20),
//                 ElevatedButton(
//                   onPressed: () => _seleccionarFecha(context),
//                   child: Text('Seleccionar Fecha'),
//                 ),
//               ],
//             ),
//             DropdownButtonFormField<String>(
//               value: horarioSeleccionado,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   horarioSeleccionado = newValue;
//                 });
//               },
//               items: listaHorarios.map((String horario) {
//                 return DropdownMenuItem<String>(
//                   value: horario,
//                   child: Text(horario),
//                 );
//               }).toList(),
//               decoration: InputDecoration(labelText: 'Horario'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // Guardar la nuevo categoría en la base de datos.
//                 int paciente = pacienteSeleccionado!.idPersona!;
//                 int doctor = doctorSeleccionado!.idPersona!;
//                 var horario = horarioSeleccionado!.toString();
//                 final nuevoTurno = Turno(
//                     idTurno: widget.turno.idTurno,
//                     paciente: paciente,
//                     doctor: doctor,
//                     fecha: fechaSeleccionadaController,
//                     horario: horario);
//                 TurnoDatabaseProvider().updateTurno(nuevoTurno);

//                 // Después de la inserción, navega a la pantalla de administración de categorías
//                 Navigator.of(context).push(MaterialPageRoute(builder: (_) {
//                   return ReservaTurnosScreen(); // Navegar a la nuevo pantalla
//                 }));
//               },
//               child: Text('Guardar Turno'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
