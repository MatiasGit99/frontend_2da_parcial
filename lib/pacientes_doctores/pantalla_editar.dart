import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/actions.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/pantalla_principal.dart';

class EditarPacienteDoctorScreen extends StatefulWidget {
  final PacienteDoctor pacienteDoctor;

  EditarPacienteDoctorScreen({required this.pacienteDoctor});

  @override
  _EditarPacienteDoctorScreenState createState() => _EditarPacienteDoctorScreenState();
}

class _EditarPacienteDoctorScreenState extends State<EditarPacienteDoctorScreen> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cedulaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.pacienteDoctor.nombre;
    apellidoController.text = widget.pacienteDoctor.apellido;
    telefonoController.text = widget.pacienteDoctor.telefono;
    emailController.text = widget.pacienteDoctor.email;
    cedulaController.text = widget.pacienteDoctor.cedula;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Paciente/Doctor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: apellidoController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: cedulaController,
              decoration: InputDecoration(labelText: 'Cédula'),
            ),
            ElevatedButton(
              onPressed: () {
                // Guardar los cambios en el paciente/doctor en la base de datos.
                final pacienteDoctorActualizado = PacienteDoctor(
                  idPersona: widget.pacienteDoctor.idPersona,
                  nombre: nombreController.text,
                  apellido: apellidoController.text,
                  telefono: telefonoController.text,
                  email: emailController.text,
                  cedula: cedulaController.text,
                  flagEsDoctor: widget.pacienteDoctor.flagEsDoctor,
                );

                // Update the paciente/doctor in the database.
                PacienteDoctorDatabaseProvider().updatePacienteDoctor(pacienteDoctorActualizado);

                // After the update, navigate back to the main screen or any other screen you want.
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return AdministracionPacientesDoctoresScreen(); // Navigate to the desired screen
                }));
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
