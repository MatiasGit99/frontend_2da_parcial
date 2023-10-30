import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';

class Turno {
  int? idTurno;
  PacienteDoctor paciente;
  PacienteDoctor doctor;
  DateTime fecha;
  String horario;

  Turno({
    this.idTurno,
    required this.paciente,
    required this.doctor,
    required this.fecha,
    required this.horario,
  });

  factory Turno.fromJson(Map<String, dynamic> json) => Turno(
        idTurno: json['idTurno'],
        paciente: json['paciente'],
        doctor: json['doctor'],
        fecha: DateTime.parse(json['fecha']),
        horario: json['horario'],
      );

  Map<String, dynamic> toJson() => {
        'idTurno': idTurno,
        'paciente': paciente,
        'doctor': doctor,
        'fecha': fecha.toIso8601String(),
        'horario': horario,
      };
}
