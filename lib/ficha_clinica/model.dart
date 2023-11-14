import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';
import 'package:frontend_2da_parcial/administracion_categorias/model.dart';

class FichaClinica {
  int? idFichaClinica;
  DateTime fechaDesde;
  DateTime fechaHasta;
  String motivoConsulta;
  String observacion;
  String diagnostico;
  Persona idDoctor;
  Persona idPaciente;
  Categoria idCategoria;

  FichaClinica({
    this.idFichaClinica,
    required this.fechaDesde,
    required this.fechaHasta,
    required this.motivoConsulta,
    required this.observacion,
    required this.diagnostico,
    required this.idDoctor,
    required this.idPaciente,
    required this.idCategoria,
  });

  factory FichaClinica.fromJson(Map<String, dynamic> json) => FichaClinica(
        idFichaClinica: json['idFichaClinica'],
        fechaDesde: DateTime.parse(json['fechaDesde']),
        fechaHasta: DateTime.parse(json['fechaHasta']),
        motivoConsulta: json['motivoConsulta'],
        observacion: json['observacion'],
        diagnostico: json['diagnostico'],
        idDoctor: Persona.fromJson(json['idDoctor']),
        idPaciente: Persona.fromJson(json['idPaciente']),
        idCategoria: Categoria.fromJson(json['idCategoria']),
      );

  Map<String, dynamic> toJson() => {
        'idFichaClinica': idFichaClinica,
        'fechaDesde': fechaDesde.toIso8601String(),
        'fechaInicio': fechaDesde.toIso8601String(),
        'motivoConsulta': motivoConsulta,
        'observacion': observacion,
        'diagnostico': diagnostico,
        'idDoctor': idDoctor.toJson(),
        'idPaciente': idPaciente.toJson(),
        'idCategoria': idCategoria.toJson(),
      };
}

