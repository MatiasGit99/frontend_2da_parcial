import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/ficha_clinica/model.dart';
import 'package:frontend_2da_parcial/ficha_clinica/actions.dart';
import 'package:frontend_2da_parcial/ficha_clinica/pantalla_agregar.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'dart:io'; // Añade esta línea para importar la biblioteca dart:io

class FichaClinicaScreen extends StatefulWidget {
  set doctorSelect(String doctorSelect) {}

  set pacienteSelect(String pacienteSelect) {}

  @override
  _FichaClinicaScreenState createState() => _FichaClinicaScreenState();
}

class _FichaClinicaScreenState extends State<FichaClinicaScreen> {
  List<FichaClinica> fichasClinicas = [];  // Cambia la lista de Turnos a FichasClinicas
  var pacienteSelect = "";
  var doctorSelect = "";
  @override
  void initState() {
    super.initState();
    widget.pacienteSelect = "";
    widget.doctorSelect = "";
    getFichasClinicas();  // Cambia la llamada a getTurnos por getFichasClinicas
  }

  Future<void> getFichasClinicas() async {
    final listaFichasClinicas = await FichaClinicaDatabaseProvider().getAllFichasClinicas();  // Cambia la llamada a TurnoDatabaseProvider por FichaClinicaDatabaseProvider
    setState(() {
      fichasClinicas = listaFichasClinicas;
    });
  }


  Future<void> updateFichaClinica(FichaClinica fichaClinica) async {
    await FichaClinicaDatabaseProvider().updateFichaClinica(fichaClinica);  // Cambia la llamada a TurnoDatabaseProvider por FichaClinicaDatabaseProvider
    getFichasClinicas();  // Cambia la llamada a getTurnos por getFichasClinicas
  }

  Future<void> deleteFichaClinica(int? idFichaClinica) async {
    if (idFichaClinica != null) {
      await FichaClinicaDatabaseProvider().deleteFichaClinica(idFichaClinica);  // Cambia la llamada a TurnoDatabaseProvider por FichaClinicaDatabaseProvider
      getFichasClinicas();  // Cambia la llamada a getTurnos por getFichasClinicas
    }
  }



  void exportToExcel(List<FichaClinica> data) async {
  final excel = Excel.createExcel();
  final sheet = excel['FichasClinicas']; // Cambia el nombre de la hoja a 'FichasClinicas'

  // Agrega encabezados
  sheet.appendRow(['ID', 'Fecha Desde', 'Fecha Hasta', 'Motivo Consulta', 'Observación', 'Diagnóstico', 'ID Doctor', 'ID Paciente', 'ID Categoría']);

  // Agrega tus datos
  for (final fichaClinica in data) {
    sheet.appendRow([
      fichaClinica.idFichaClinica,
      fichaClinica.fechaDesde,
      fichaClinica.fechaHasta,
      fichaClinica.motivoConsulta,
      fichaClinica.observacion,
      fichaClinica.diagnostico,
      fichaClinica.doctor_nombre,
      fichaClinica.paciente_nombre,
      fichaClinica.idCategoria_nombre
    ]);
  }

  // Guarda el archivo Excel en el directorio de documentos
  final directory = await getApplicationDocumentsDirectory();
  final fileName = 'fichasClinicas.xlsx';
  final downloadsDirectory = '/storage/emulated/0/Download';
  final filePath = '$downloadsDirectory/$fileName';

  final excelData = await excel.encode(); // Espera la finalización del Future

  if (excelData != null) {
    await File(filePath).writeAsBytes(excelData);
  } else {
    print('Error al exportar a Excel'); // Manejo de errores
  }
}

void exportToPDF(List<FichaClinica> data) async {
  final pdf = pw.Document();
  // Agrega un título
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Center(
          child: pw.Text('Fichas Clínicas', style: pw.TextStyle(fontSize: 24)),
        );
      },
    ),
  );

  // Agrega tus datos
  for (final fichaClinica in data) {
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            children: [
              pw.Text('ID: ${fichaClinica.idFichaClinica}'),
              pw.Text('Fecha Desde: ${fichaClinica.fechaDesde}'),
              pw.Text('Fecha Hasta: ${fichaClinica.fechaHasta}'),
              pw.Text('Motivo Consulta: ${fichaClinica.motivoConsulta}'),
              pw.Text('Observación: ${fichaClinica.observacion}'),
              pw.Text('Diagnóstico: ${fichaClinica.diagnostico}'),
              pw.Text('ID Doctor: ${fichaClinica.doctor_nombre}'),
              pw.Text('ID Paciente: ${fichaClinica.paciente_nombre}'),
              pw.Text('ID Categoría: ${fichaClinica.idCategoria_nombre}'),
              pw.Divider(),
            ],
          );
        },
      ),
    );
  }

  // Guarda el archivo PDF en el directorio de documentos
  final directory = await getApplicationDocumentsDirectory();
  // final filePath = '${directory.path}/fichasClinicas.pdf';
  final fileName = 'fichasClinicas.pdf';

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
        title: Text('Reserva de Turnos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aquí puedes mostrar la lista de categorías.
            ListView.builder(
              shrinkWrap: true,
              itemCount: fichasClinicas.length,
              itemBuilder: (BuildContext context, index) {
                final fichaClinica = fichasClinicas[index];
                // obtenerPacientePorId(fichaClinica.idPaciente.idPersona);  // Cambia la propiedad paciente por idPaciente
                // obtenerMedicoPorId(fichaClinica.idDoctor.idPersona);  // Cambia la propiedad doctor por idDoctor
                return ListTile(
                  title: Text(
                      'Paciente: $pacienteSelect'),
                  subtitle:
                      Text('Médico: $doctorSelect Fecha Inicio-Final: ${DateFormat('dd/MM/yyyy').format(fichaClinica.fechaDesde)} - ${DateFormat('dd/MM/yyyy').format(fichaClinica.fechaHasta)}'),  // Cambia las propiedades fecha y horario por fechaDesde y fechaHasta
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteFichaClinica(fichaClinica.idFichaClinica);
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
                  return AgregarFichaClinicaForm();
                }));
              },
              child: Text('Agregar Ficha'),
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
