class PacienteDoctor {
  int? idPersona;
  String nombre;
  String apellido;
  String telefono;
  String email;
  String cedula;
  int flagEsDoctor;

  PacienteDoctor({
    required this.idPersona,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    required this.cedula,
    required this.flagEsDoctor,
  });

  factory PacienteDoctor.fromJson(Map<String, dynamic> json) {
    return PacienteDoctor(
      idPersona: json['idPersona'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      telefono: json['telefono'],
      email: json['email'],
      cedula: json['cedula'],
      flagEsDoctor: json['flagEsDoctor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idPersona': idPersona,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'email': email,
      'cedula': cedula,
      'flagEsDoctor': flagEsDoctor,
    };
  }
}
