import 'package:flutter/material.dart';
import 'package:frontend_2da_parcial/administracion_categorias/model.dart';
import 'package:frontend_2da_parcial/administracion_categorias/actions.dart';
import 'package:frontend_2da_parcial/administracion_categorias/pantalla_agregar.dart';
import 'package:frontend_2da_parcial/administracion_categorias/pantalla_editar.dart';

class AdministracionCategoriasScreen extends StatefulWidget {
  @override
  _AdministracionCategoriasScreenState createState() =>
      _AdministracionCategoriasScreenState();
}

class _AdministracionCategoriasScreenState
    extends State<AdministracionCategoriasScreen> {
  List<Categoria> categorias = [];

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
            // Aquí puedes mostrar la lista de categorías.
            ListView.builder(
              shrinkWrap: true,
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
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
