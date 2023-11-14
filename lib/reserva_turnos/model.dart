import 'package:frontend_2da_parcial/pacientes_doctores/model.dart';

class Turno {
  int? idTurno;
  int paciente;
  int doctor;
  DateTime fecha;
  String horario;
  String paciente_nombre;
  String doctor_nombre;
  String flagEstado;

  Turno({
    this.idTurno,
    required this.paciente,
    required this.doctor,
    required this.fecha,
    required this.horario,
    required this.paciente_nombre,
    required this.doctor_nombre,
    this.flagEstado = 'Activo',

  });

factory Turno.fromJson(Map<String, dynamic> json) => Turno(
  idTurno: json['idTurno']?? '', // Usa '' si es nulo
  paciente: json['idPaciente']?? '', // Usa '' si es nulo
  doctor: json['idDoctor']?? '', // Usa '' si es nulo
  fecha: DateTime.parse(json['fecha']), // Usa '' si es nulo
  horario: json['horario']?? '', // Usa '' si es nulo
  paciente_nombre: json['paciente_nombre'] ?? '', // Usa '' si es nulo
  doctor_nombre: json['doctor_nombre'] ?? '', // Usa '' si es nulo
  flagEstado: json['flagEstado'] ?? '', // Usa '' si es nulo
);


  Map<String, dynamic> toJson() => {
        'idTurno': idTurno,
        'idPaciente': paciente,
        'idDoctor': doctor,
        'fecha': fecha.toIso8601String(),
        'horario': horario,
        'paciente_nombre': paciente_nombre,
        'doctor_nombre': doctor_nombre,
        'flagEstado': flagEstado,
      };
}
