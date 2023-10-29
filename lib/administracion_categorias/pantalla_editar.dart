import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/administracion_categorias/actions.dart';
import 'package:frontend_2da_parcial/administracion_categorias/model.dart';
import 'package:frontend_2da_parcial/administracion_categorias/pantalla_principal.dart';

class EditarCategoriaScreen extends StatefulWidget {
  final Categoria categoria;

  EditarCategoriaScreen({required this.categoria});

  @override
  _EditarCategoriaScreenState createState() => _EditarCategoriaScreenState();
}

class _EditarCategoriaScreenState extends State<EditarCategoriaScreen> {
  TextEditingController descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    descripcionController.text = widget.categoria.descripcion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Categoría'),
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
                // Guardar los cambios en la categoría en la base de datos.
                final categoriaActualizada = Categoria(
                  idCategoria: widget.categoria.idCategoria,
                  descripcion: descripcionController.text,
                );
                CategoriaDatabaseProvider().updateCategoria(categoriaActualizada);

                // Después de la inserción, navega a la pantalla de administración de categorías
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return AdministracionCategoriasScreen(); // Navegar a la nueva pantalla
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
