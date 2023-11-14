import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/ficha_clinica/model.dart';
import 'package:frontend_2da_parcial/ficha_clinica/actions.dart';
import 'package:frontend_2da_parcial/ficha_clinica/pantalla_agregar.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'dart:io'; // Añade esta línea para importar la biblioteca dart:io
import 'package:permission_handler/permission_handler.dart';

class FichaClinicaScreen extends StatefulWidget {
  set doctorSelect(String doctorSelect) {}

  set pacienteSelect(String pacienteSelect) {}

  @override
  _FichaClinicaScreenState createState() => _FichaClinicaScreenState();
}

class _FichaClinicaScreenState extends State<FichaClinicaScreen> {
  List<FichaClinica> fichasClinicas = [];
  List<FichaClinica> fichasFiltrados = [];
  var pacienteSelect = "";
  var doctorSelect = "";
  String selectedFilter = 'Doctor';
  final TextEditingController fechaDesdeController = TextEditingController();
  final TextEditingController fechaHastaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.pacienteSelect = "";
    widget.doctorSelect = "";
    getFichasClinicas();
  }

  Future<void> getFichasClinicas() async {
    final listaFichasClinicas =
        await FichaClinicaDatabaseProvider().getAllFichasClinicas();
    setState(() {
      fichasClinicas = listaFichasClinicas;
      fichasFiltrados = listaFichasClinicas;
    });
  }

  Future<void> updateFichaClinica(FichaClinica fichaClinica) async {
    await FichaClinicaDatabaseProvider().updateFichaClinica(fichaClinica);
    getFichasClinicas();
  }

  Future<void> deleteFichaClinica(int? idFichaClinica) async {
    if (idFichaClinica != null) {
      await FichaClinicaDatabaseProvider().deleteFichaClinica(idFichaClinica);
      getFichasClinicas();
    }
  }

  void filterFichas(String searchText) {
    setState(() {
      fichasFiltrados = fichasClinicas.where((fichaClinica) {
        if (selectedFilter == 'Doctor') {
          return fichaClinica.doctor_nombre
              .toLowerCase()
              .contains(searchText.toLowerCase());
        } else if (selectedFilter == 'Paciente') {
          return fichaClinica.paciente_nombre
              .toLowerCase()
              .contains(searchText.toLowerCase());
        } else if (selectedFilter == 'Categoría') {
          return fichaClinica.idCategoria_nombre
              .toLowerCase()
              .contains(searchText.toLowerCase());
        } else if (selectedFilter == 'Fecha desde') {
          return fichaClinica.fechaDesde != null &&
              fichaClinica.fechaDesde
                  .isAfter(DateFormat('dd/MM/yyyy').parse(searchText));
        } else if (selectedFilter == 'Fecha hasta') {
          return fichaClinica.fechaHasta != null &&
              fichaClinica.fechaHasta.isBefore(
                  DateFormat('dd/MM/yyyy').parse(searchText).add(Duration(days: 1)));
        } else {
          return fichaClinica.idFichaClinica != null &&
              fichaClinica.idFichaClinica.toString() == searchText;
        }
      }).toList();
    });
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        filterFichas(controller.text);
      });
    }
  }

  void filterFichasByDateRange() {
    setState(() {
      fichasFiltrados = fichasClinicas.where((fichaClinica) {
        if (selectedFilter == 'Fecha desde') {
          return fichaClinica.fechaDesde != null &&
              fichaClinica.fechaDesde.isAfter(
                  DateFormat('dd/MM/yyyy').parse(fechaDesdeController.text));
        } else if (selectedFilter == 'Fecha hasta') {
          return fichaClinica.fechaHasta != null &&
              fichaClinica.fechaHasta.isBefore(
                  DateFormat('dd/MM/yyyy').parse(fechaHastaController.text).add(Duration(days: 1)));
        } else {
          return true;
        }
      }).toList();
    });
  }

void exportToExcel(List<FichaClinica> data) async {
  final excel = Excel.createExcel();
  final sheet = excel['Sheet1'];

  // Add headers at the beginning of the document
  sheet.appendRow([
    'ID',
    'Fecha Desde',
    'Fecha Hasta',
    'Motivo Consulta',
    'Observación',
    'Diagnóstico',
    'ID Doctor',
    'ID Paciente',
    'ID Categoría'
  ]);

  // Add real data below the headers
  data.forEach((fichaClinica) {
    sheet.appendRow([
      fichaClinica.idFichaClinica?.toString() ?? '',
      fichaClinica.fechaDesde?.toString() ?? '',
      fichaClinica.fechaHasta?.toString() ?? '',
      fichaClinica.motivoConsulta ?? '',
      fichaClinica.observacion ?? '',
      fichaClinica.diagnostico ?? '',
      fichaClinica.doctor_nombre ?? '',
      fichaClinica.paciente_nombre ?? '',
      fichaClinica.idCategoria_nombre ?? ''
    ]);
  });

  // Save the Excel file
  final fileName = 'fichasClinicas.xlsx';
  final downloadsDirectory = '/storage/emulated/0/Download';
  final filePath = '$downloadsDirectory/$fileName';

  var excelBytes = excel.encode()!; // Use the null assertion operator

  // Write to file
  await File(filePath).writeAsBytes(excelBytes);
}

  void exportToPDF(List<FichaClinica> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Text('Fichas Clínicas', style: pw.TextStyle(fontSize: 24)),
          );
        },
      ),
    );

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

    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'fichasClinicas.pdf';
    final downloadsDirectory = '/storage/emulated/0/Download';
    final filePath = '$downloadsDirectory/$fileName';

    final file = File(filePath);
    print(filePath);

    final pdfData = await pdf.save();

    if (pdfData != null) {
      final pdfBytes = pdfData.buffer.asUint8List();
      await file.writeAsBytes(pdfBytes);
    } else {
      print('Error al exportar a PDF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fichas Clínicas'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  items: <String>[
                    'Doctor',
                    'Paciente',
                    'Categoría',
                    'Fecha desde',
                    'Fecha hasta'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(width: 16),
              ],
            ),
            if (selectedFilter == 'Fecha desde' || selectedFilter == 'Fecha hasta')
              TextField(
                onChanged: (value) {
                  filterFichas(value);
                },
                controller: selectedFilter == 'Fecha desde'
                    ? fechaDesdeController
                    : fechaHastaController,
                onTap: () => _selectDate(selectedFilter == 'Fecha desde'
                    ? fechaDesdeController
                    : fechaHastaController),
                decoration: InputDecoration(
                  labelText: selectedFilter == 'Fecha desde'
                      ? 'Fecha Desde'
                      : 'Fecha Hasta',
                ),
              )
            else
              TextField(
                onChanged: (value) {
                  filterFichas(value);
                },
                decoration: InputDecoration(labelText: 'Buscar'),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (selectedFilter == 'Fecha desde' ||
                        selectedFilter == 'Fecha hasta') {
                      filterFichasByDateRange();
                    } else {
                      filterFichas('');
                    }
                  },
                  child: Text('Filtro'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    exportToExcel(fichasFiltrados);
                  },
                  child: Text('Exportar a Excel'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    exportToPDF(fichasFiltrados);
                  },
                  child: Text('Exportar a PDF'),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: fichasFiltrados.length,
              itemBuilder: (BuildContext context, index) {
                final fichaClinica = fichasFiltrados[index];
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Paciente: ${fichaClinica.paciente_nombre}'),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Médico: ${fichaClinica.doctor_nombre}'),
                      Text(
                          'Categoría: ${fichaClinica.idCategoria_nombre}'),
                      Text(
                          'Fecha Inicio-Final: ${DateFormat('dd/MM/yyyy').format(fichaClinica.fechaDesde)} - ${DateFormat('dd/MM/yyyy').format(fichaClinica.fechaHasta)}'),
                    ],
                  ),
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
          ],
        ),
      ),
    );
  }
}
