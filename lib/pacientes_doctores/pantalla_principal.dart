import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/actions.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/pantalla_agregar.dart';

class AdministracionPacientesDoctoresScreen extends StatefulWidget {
  @override
  _AdministracionPacientesDoctoresScreenState createState() =>
      _AdministracionPacientesDoctoresScreenState();
}

class _AdministracionPacientesDoctoresScreenState
    extends State<AdministracionPacientesDoctoresScreen> {
  List<PacienteDoctor> pacientesDoctores = [];

  @override
  void initState() {
    super.initState();
    getPacientesDoctores();
  }

  Future<void> getPacientesDoctores() async {
    final listaPacientesDoctores =
        await PacienteDoctorDatabaseProvider().getAllPacientesDoctores();
    setState(() {
      pacientesDoctores = listaPacientesDoctores;
    });
  }

  Future<void> insertPacienteDoctor() async {
    final nuevoPacienteDoctor = PacienteDoctor(
        idPersona: null,
        nombre: 'Nuevo Nombre',
        apellido: 'Nuevo Apellido',
        telefono: 'Nuevo Teléfono',
        email: 'Nuevo Email',
        cedula: 'Nueva Cédula',
        flagEsDoctor: 1); // Ajusta los valores según tu caso

    await PacienteDoctorDatabaseProvider().insertPacienteDoctor(nuevoPacienteDoctor);
    getPacientesDoctores();
  }

  Future<void> updatePacienteDoctor(PacienteDoctor pacienteDoctor) async {
    await PacienteDoctorDatabaseProvider().updatePacienteDoctor(pacienteDoctor);
    getPacientesDoctores();
  }

  Future<void> deletePacienteDoctor(int? idPersona) async {
    if (idPersona != null) {
      await PacienteDoctorDatabaseProvider().deletePacienteDoctor(idPersona);
      getPacientesDoctores();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administración de Pacientes y Doctores'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return AgregarPacienteDoctorForm();
                }));
              },
              child: Text('Agregar Paciente o Doctor'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(200, 48)),
              ),
            ),
            // Aquí puedes mostrar la lista de pacientes y doctores.
            ListView.builder(
              shrinkWrap: true,
              itemCount: pacientesDoctores.length,
              itemBuilder: (context, index) {
                final pacienteDoctor = pacientesDoctores[index];
                return ListTile(
                  title: Text('${pacienteDoctor.nombre} ${pacienteDoctor.apellido}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          updatePacienteDoctor(pacienteDoctor);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deletePacienteDoctor(pacienteDoctor.idPersona);
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
