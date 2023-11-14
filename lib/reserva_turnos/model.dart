import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';

class Turno {
  int? idTurno;
  int paciente;
  int doctor;
  DateTime fecha;
  String horario;
  String paciente_nombre;
  String doctor_nombre;

  Turno({
    this.idTurno,
    required this.paciente,
    required this.doctor,
    required this.fecha,
    required this.horario,
    required this.paciente_nombre,
    required this.doctor_nombre,
  });

factory Turno.fromJson(Map<String, dynamic> json) => Turno(
  idTurno: json['idTurno'],
  paciente: json['idPaciente'],
  doctor: json['idDoctor'],
  fecha: DateTime.parse(json['fecha']),
  horario: json['horario'],
  paciente_nombre: json['paciente_nombre'] ?? '', // Usa '' si es nulo
  doctor_nombre: json['doctor_nombre'] ?? '', // Usa '' si es nulo
);


  Map<String, dynamic> toJson() => {
        'idTurno': idTurno,
        'idPaciente': paciente,
        'idDoctor': doctor,
        'fecha': fecha.toIso8601String(),
        'horario': horario,
        'paciente_nombre': paciente_nombre,
        'doctor_nombre': doctor_nombre,
      };
}
