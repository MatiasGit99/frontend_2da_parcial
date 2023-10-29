class Categoria {
  int? idCategoria;
  String descripcion;

  Categoria({
    required this.idCategoria,
    required this.descripcion,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        idCategoria: json['idCategoria'],
        descripcion: json['descripcion'],
      );

  Map<String, dynamic> toJson() => {
        'idCategoria': idCategoria,
        'descripcion': descripcion,
      };
}
