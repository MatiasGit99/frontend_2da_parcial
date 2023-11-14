import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/actions.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';
import 'package:frontend_2da_parcial/reserva_turnos/actions.dart';
import 'package:frontend_2da_parcial/reserva_turnos/model.dart';
import 'package:frontend_2da_parcial/reserva_turnos/pantalla_principal.dart';
import 'package:intl/intl.dart';

class AgregarFichaClinicaForm extends StatefulWidget {
  @override
  _AgregarFichaClinicaFormState createState() => _AgregarFichaClinicaFormState();
}

class _AgregarFichaClinicaFormState extends State<AgregarFichaClinicaForm> {
  final TextEditingController descripcionController = TextEditingController();
  DateTime fechaDesdeSeleccionada = DateTime.now();
  DateTime fechaHastaSeleccionada = DateTime.now();
  PacienteDoctor? doctorSeleccionado;
  List<PacienteDoctor> listaDoctores = [];
  PacienteDoctor? pacienteSeleccionado;
  List<PacienteDoctor> listaPacientes = [];
  Categoria? categoriaSeleccionada;
  List<Categoria> listaCategorias = [];

  @override
  void initState() {
    super.initState();
    cargarMedicosPacientesCategorias();
  }

  Future<void> cargarMedicosPacientesCategorias() async {
    final doctores = await PacienteDoctorDatabaseProvider().getAllDoctores();
    final pacientes = await PacienteDoctorDatabaseProvider().getAllPacientes();
    final categorias = await CategoriaDatabaseProvider().getAllCategorias();

    setState(() {
      listaDoctores = doctores;
      listaPacientes = pacientes;
      listaCategorias = categorias;
    });
  }

  Future<void> _seleccionarFechaDesde(BuildContext context) async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: fechaDesdeSeleccionada,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (seleccionada != null && seleccionada != fechaDesdeSeleccionada) {
      setState(() {
        fechaDesdeSeleccionada = seleccionada;
      });
    }
  }

  Future<void> _seleccionarFechaHasta(BuildContext context) async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: fechaHastaSeleccionada,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (seleccionada != null && seleccionada != fechaHastaSeleccionada) {
      setState(() {
        fechaHastaSeleccionada = seleccionada;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Ficha Clínica'),
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

            DropdownButtonFormField<Categoria>(
              value: categoriaSeleccionada,
              onChanged: (Categoria? newValue) {
                setState(() {
                  categoriaSeleccionada = newValue;
                });
              },
              items: listaCategorias.map((Categoria categoria) {
                return DropdownMenuItem<Categoria>(
                  value: categoria,
                  child: Text('${categoria.descripcion}'),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Categoría'),
            ),

            Row(
              children: [
                Text('Fecha Desde: '),
                Text(DateFormat('dd/MM/yyyy').format(fechaDesdeSeleccionada)),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _seleccionarFechaDesde(context),
                  child: Text('Seleccionar Fecha'),
                ),
              ],
            ),

            Row(
              children: [
                Text('Fecha Hasta: '),
                Text(DateFormat('dd/MM/yyyy').format(fechaHastaSeleccionada)),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _seleccionarFechaHasta(context),
                  child: Text('Seleccionar Fecha'),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: () {
                // Guardar la nueva ficha clínica en la base de datos.
                int paciente = pacienteSeleccionado!.idPersona!;
                int doctor = doctorSeleccionado!.idPersona!;
                int categoria = categoriaSeleccionada!.idCategoria!;
                final nuevaFichaClinica = FichaClinica(
                  fechaDesde: fechaDesdeSeleccionada,
                  fechaHasta: fechaHastaSeleccionada,
                  motivoConsulta: 'Motivo de Consulta', // Puedes modificar este valor según tus necesidades
                  observacion: 'Observación', // Puedes modificar este valor según tus necesidades
                  diagnostico: 'Diagnóstico', // Puedes modificar este valor según tus necesidades
                  idDoctor: doctorSeleccionado!,
                  idPaciente: pacienteSeleccionado!,
                  idCategoria: categoriaSeleccionada!,
                );

                FichaClinicaDatabaseProvider().insertFichaClinica(nuevaFichaClinica);

                // Después de la inserción, navega a la pantalla de administración de categorías
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return ReservaTurnosScreen(); // Navegar a la nueva pantalla
                }));
              },
              child: Text('Guardar Ficha Clínica'),
            ),
          ],
        ),
      ),
    );
  }
}
