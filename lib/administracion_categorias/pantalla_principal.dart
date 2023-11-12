import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/administracion_categorias/model.dart';
import 'package:frontend_2da_parcial/administracion_categorias/actions.dart';
import 'package:frontend_2da_parcial/administracion_categorias/pantalla_agregar.dart';
import 'package:frontend_2da_parcial/administracion_categorias/pantalla_editar.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'dart:io'; // Añade esta línea para importar la biblioteca dart:io



class AdministracionCategoriasScreen extends StatefulWidget {
  @override
  _AdministracionCategoriasScreenState createState() =>
      _AdministracionCategoriasScreenState();
}

class _AdministracionCategoriasScreenState
    extends State<AdministracionCategoriasScreen> {
  List<Categoria> categorias = [];
  List<Categoria> categoriasFiltradas = [];
  String selectedFilter = 'Descripción';

  @override
  void initState() {
    super.initState();
    getCategorias();
  }

  Future<void> getCategorias() async {
    final listaCategorias =
        await CategoriaDatabaseProvider().getAllCategorias();
    setState(() {
      categorias = listaCategorias;
      categoriasFiltradas = listaCategorias;
    });
  }

  Future<void> insertCategoria() async {
    final nuevaCategoria =
        Categoria(idCategoria: null, descripcion: 'Nueva Categoría');
    await CategoriaDatabaseProvider().insertCategoria(nuevaCategoria);
    getCategorias();
  }

  Future<void> updateCategoria(Categoria categoria) async {
    await CategoriaDatabaseProvider().updateCategoria(categoria);
    getCategorias();
  }

  Future<void> deleteCategoria(int? idCategoria) async {
    if (idCategoria != null) {
      await CategoriaDatabaseProvider().deleteCategoria(idCategoria);
      getCategorias();
    }
  }

  void filterCategorias(String searchText) {
    setState(() {
      categoriasFiltradas = categorias.where((categoria) {
        if (selectedFilter == 'Descripción') {
          return categoria.descripcion
              .toLowerCase()
              .contains(searchText.toLowerCase());
        } else {
          return categoria.idCategoria != null &&
              categoria.idCategoria.toString() == searchText;
        }
      }).toList();
    });
  }


void exportToExcel(List<Categoria> data) async {
  final excel = Excel.createExcel();
  final sheet = excel['Categorías'];

  // Agrega encabezados
  sheet.appendRow(['ID', 'Descripción']);

  // Agrega tus datos
  for (final categoria in data) {
    sheet.appendRow([categoria.idCategoria, categoria.descripcion]);
  }

  // Guarda el archivo Excel en el directorio de documentos
  final directory = await getApplicationDocumentsDirectory();
  final fileName = 'categorias.xlsx';
  final downloadsDirectory = '/storage/emulated/0/Download';
   final filePath = '$downloadsDirectory/$fileName';

  final excelData = await excel.encode(); // Espera la finalización del Future

  if (excelData != null) {
    await File(filePath).writeAsBytes(excelData);
  } else {
    print('Error al exportar a Excel'); // Manejo de errores
  }
}

void exportToPDF(List<Categoria> data) async {
  final pdf = pw.Document();
  // Agrega un título
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Center(
          child: pw.Text('Categorías', style: pw.TextStyle(fontSize: 24)),
        );
      },
    ),
  );

  // Agrega tus datos
  for (final categoria in data) {
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            children: [
              pw.Text('ID: ${categoria.idCategoria}'),
              pw.Text('Descripción: ${categoria.descripcion}'),
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
    final fileName = 'categorias.pdf';

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
        title: Text('Administración de Categorías'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  items: <String>['Descripción', 'Fecha']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return AgregarCategoriaForm();
                }));
              },
              child: Text('Agregar Categoría'),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    exportToExcel(categoriasFiltradas);
                  },
                  child: Text('Exportar a Excel'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    exportToPDF(categoriasFiltradas);
                  },
                  child: Text('Exportar a PDF'),
                ),
              ],
            ),
            // Mostrar la lista de categorías filtradas
            ListView.builder(
              shrinkWrap: true,
              itemCount: categoriasFiltradas.length,
              itemBuilder: (context, index) {
                final categoria = categoriasFiltradas[index];
                return ListTile(
                  title: Text(categoria.descripcion),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Obtén la categoría que deseas editar, puedes hacerlo a través de una consulta a la base de datos o como lo necesites.
                          final categoriaAEditar = Categoria(
                          idCategoria: categoria.idCategoria,// asigna el ID de la categoría que deseas editar,
                          descripcion: categoria.descripcion,);

                          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                            return EditarCategoriaScreen(categoria: categoriaAEditar); // Pasa la categoría a editar a la pantalla de edición
                          }));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteCategoria(categoria.idCategoria);
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
