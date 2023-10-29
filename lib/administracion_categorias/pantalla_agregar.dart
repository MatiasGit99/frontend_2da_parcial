import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/administracion_categorias/model.dart'; // Importa el modelo de Categoría
import 'package:frontend_2da_parcial/administracion_categorias/actions.dart'; // Importa el modelo de Categoría
import 'package:frontend_2da_parcial/administracion_categorias/pantalla_principal.dart'; // Importa el modelo de Categoría

class AgregarCategoriaForm extends StatefulWidget {
  @override
  _AgregarCategoriaFormState createState() => _AgregarCategoriaFormState();
}

class _AgregarCategoriaFormState extends State<AgregarCategoriaForm> {
  final TextEditingController descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Categoría'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            ElevatedButton(
              onPressed: () {
                // Guardar la nueva categoría en la base de datos.
                final nuevaCategoria = Categoria(
                  idCategoria: null,
                  descripcion: descripcionController.text,
                );
                CategoriaDatabaseProvider().insertCategoria(nuevaCategoria);

                // Después de la inserción, navega a la pantalla de administración de categorías
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return AdministracionCategoriasScreen(); // Navegar a la nueva pantalla
                }));
              },
              child: Text('Guardar Categoría'),
            ),
          ],
        ),
      ),
    );
  }
}
