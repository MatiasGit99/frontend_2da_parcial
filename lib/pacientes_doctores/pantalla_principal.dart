import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/actions.dart';
import 'package:frontend_2da_parcial/pacientes_doctores/pantalla_agregar.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'dart:io';

class AdministracionPacientesDoctoresScreen extends StatefulWidget {
  @override
  _AdministracionPacientesDoctoresScreenState createState() =>
      _AdministracionPacientesDoctoresScreenState();
}

class _AdministracionPacientesDoctoresScreenState
    extends State<AdministracionPacientesDoctoresScreen> {
  List<PacienteDoctor> pacientesDoctores = [];
  List<PacienteDoctor> pacientesDoctoresFiltrados = [];
  String selectedFilter = 'Nombre';
  bool mostrarSoloDoctores = false;

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
      pacientesDoctoresFiltrados = listaPacientesDoctores;
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

    await PacienteDoctorDatabaseProvider()
        .insertPacienteDoctor(nuevoPacienteDoctor);
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

  void filterCategorias(String searchText) {
    setState(() {
      pacientesDoctoresFiltrados = pacientesDoctores.where((pacientesDoctores) {
        if (mostrarSoloDoctores && pacientesDoctores.flagEsDoctor != 1) {
          return false;
        }

        if (selectedFilter == 'Nombre') {
          return pacientesDoctores.nombre
              .toLowerCase()
              .contains(searchText.toLowerCase());
        } else if (selectedFilter == 'Apellido') {
          return pacientesDoctores.apellido
              .toLowerCase()
              .contains(searchText.toLowerCase());
        } else {
          return pacientesDoctores.idPersona != null &&
              pacientesDoctores.idPersona.toString() == searchText;
        }
      }).toList();
    });
  }

  void exportToExcel(List<PacienteDoctor> data) async {
    final excel = Excel.createExcel();
    final sheet = excel['Listado de Pacientes y Doctores'];

    // Agrega encabezados
    sheet.appendRow(['ID', 'Nombre']);

    // Agrega tus datos
    for (final paciente_doctor in data) {
      sheet.appendRow([paciente_doctor.idPersona, paciente_doctor.nombre]);
    }

    // Guarda el archivo Excel en el directorio de documentos
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'paciente_doctor.xlsx';
    final downloadsDirectory = '/storage/emulated/0/Download';
    final filePath = '$downloadsDirectory/$fileName';

    final excelData = await excel.encode(); // Espera la finalización del Future

    if (excelData != null) {
      await File(filePath).writeAsBytes(excelData);
    } else {
      print('Error al exportar a Excel'); // Manejo de errores
    }
  }

  void exportToPDF(List<PacienteDoctor> data) async {
    final pdf = pw.Document();
    // Agrega un título
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Text('Listado de Pacientes y Doctores',
                style: pw.TextStyle(fontSize: 24)),
          );
        },
      ),
    );

    // Agrega tus datos
    for (final paciente_doctor in data) {
      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              children: [
                pw.Text('ID: ${paciente_doctor.idPersona}'),
                pw.Text('Descripción: ${paciente_doctor.nombre}'),
                pw.Divider(),
              ],
            );
          },
        ),
      );
    }

    // Guarda el archivo PDF en el directorio de documentos
    final directory = await getApplicationDocumentsDirectory();
    // final filePath = '${directory.path}/categorias.pdf';
    final fileName = 'paciente_doctor.pdf';

    final downloadsDirectory = '/storage/emulated/0/Download';
    final filePath = '$downloadsDirectory/$fileName';

    final file = File(filePath);
    print(filePath);

    // Espera a que el Future se complete y obtén los datos del archivo PDF
    final pdfData = await pdf.save();

    if (pdfData != null) {
      // Convierte los datos del archivo PDF en una lista de enteros
      final pdfBytes = pdfData.buffer.asUint8List();

      // Escribe los datos en el archivo
      await file.writeAsBytes(pdfBytes);
    } else {
      print('Error al exportar a PDF'); // Manejo de errores
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
            TextField(
              onChanged: (value) {
                filterCategorias(value);
              },
              decoration: InputDecoration(labelText: 'Buscar'),
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
                  items: <String>['Nombre', 'Apellido']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 16), // Espaciado para separar los elementos
                Checkbox(
                  value: mostrarSoloDoctores,
                  onChanged: (value) {
                    setState(() {
                      mostrarSoloDoctores = value!;
                      filterCategorias('');
                    });
                  },
                ),
                Text('Mostrar solo Doctores'),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    exportToExcel(pacientesDoctoresFiltrados);
                  },
                  child: Text('Exportar a Excel'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    exportToPDF(pacientesDoctoresFiltrados);
                  },
                  child: Text('Exportar a PDF'),
                ),
              ],
            ),
            // Aquí puedes mostrar la lista de pacientes y doctores.
            ListView.builder(
              shrinkWrap: true,
              itemCount: pacientesDoctoresFiltrados.length,
              itemBuilder: (context, index) {
                final pacienteDoctor = pacientesDoctoresFiltrados[index];
                return ListTile(
                  title: Text(
                      '${pacienteDoctor.nombre} ${pacienteDoctor.apellido}'),
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
