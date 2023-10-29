import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/actions.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/screen.dart';

class AgregarPacienteDoctorForm extends StatefulWidget {
  @override
  _AgregarPacienteDoctorFormState createState() =>
      _AgregarPacienteDoctorFormState();
}

class _AgregarPacienteDoctorFormState extends State<AgregarPacienteDoctorForm> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  bool esDoctor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Paciente o Doctor'),
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
            Row(
              children: [
                Text('Es Doctor: '),
                Checkbox(
                  value: esDoctor,
                  onChanged: (value) {
                    setState(() {
                      esDoctor = value!;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Guardar el nuevo paciente o doctor en la base de datos.
                final nuevoPacienteDoctor = PacienteDoctor(
                  idPersona: null,
                  nombre: nombreController.text,
                  apellido: apellidoController.text,
                  telefono: telefonoController.text,
                  email: emailController.text,
                  cedula: cedulaController.text,
                  flagEsDoctor: esDoctor ? 1 : 0,
                );
                print("HOLALA");
                print(nuevoPacienteDoctor.flagEsDoctor);
                
                PacienteDoctorDatabaseProvider()
                    .insertPacienteDoctor(nuevoPacienteDoctor);

                // Después de la inserción, navega a la pantalla de administración de pacientes y doctores.
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return AdministracionPacientesDoctoresScreen();
                }));
              },
              child: Text('Guardar Paciente o Doctor'),
            ),
          ],
        ),
      ),
    );
  }
}
