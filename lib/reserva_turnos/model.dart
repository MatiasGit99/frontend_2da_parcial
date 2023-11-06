import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';

class Turno {
  int? idTurno;
  int paciente;
  int doctor;
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
        paciente: json['idPaciente'],
        doctor: json['idDoctor'],
        fecha: DateTime.parse(json['fecha']),
        horario: json['horario'],
      );

  Map<String, dynamic> toJson() => {
        'idTurno': idTurno,
        'idPaciente': paciente,
        'idDoctor': doctor,
        'fecha': fecha.toIso8601String(),
        'horario': horario,
      };
}
