import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';
import 'package:frontend_2da_parcial/administracion_categorias/model.dart';

class FichaClinica {
  int? idFichaClinica;
  DateTime fechaDesde;
  DateTime fechaHasta;
  String motivoConsulta;
  String observacion;
  String diagnostico;
  int idDoctor;
  int idPaciente;
  String paciente_nombre;
  String doctor_nombre;
  int idCategoria;
  String idCategoria_nombre;

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
    required this.paciente_nombre,
    required this.doctor_nombre,
    required this.idCategoria_nombre,

  });

  factory FichaClinica.fromJson(Map<String, dynamic> json) => FichaClinica(
        idFichaClinica: json['idFichaClinica'],
        fechaDesde: DateTime.parse(json['fechaDesde']),
        fechaHasta: DateTime.parse(json['fechaHasta']),
        motivoConsulta: json['motivoConsulta'],
        observacion: json['observacion'],
        diagnostico: json['diagnostico'],
        idDoctor: json['idDoctor'],
        idPaciente: json['idPaciente'],
        idCategoria: json['idCategoria'],
        paciente_nombre: json['paciente_nombre'],
        doctor_nombre: json['doctor_nombre'],
        idCategoria_nombre: json['idCategoria_nombre'],

      );

  Map<String, dynamic> toJson() => {
        'idFichaClinica': idFichaClinica,
        'fechaDesde': fechaDesde.toIso8601String(),
        'fechaInicio': fechaDesde.toIso8601String(),
        'motivoConsulta': motivoConsulta,
        'observacion': observacion,
        'diagnostico': diagnostico,
        'idDoctor': idDoctor,
        'idPaciente': idPaciente,
        'idCategoria': idCategoria,
        'paciente_nombre': paciente_nombre,
        'doctor_nombre': doctor_nombre,
        'idCategoria_nombre': idCategoria_nombre,
      };
}

