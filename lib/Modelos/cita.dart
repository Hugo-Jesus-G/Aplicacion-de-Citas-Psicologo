class Cita {
  String alumnoId;
  bool asistencia;
  String fecha;
  String hora;
  String motivo;
  String psicologoId;

  Cita({
    required this.alumnoId,
    required this.asistencia,
    required this.fecha,
    required this.hora,
    required this.motivo,
    required this.psicologoId,
  });

  // Método para convertir un objeto Cita a un mapa (por ejemplo, para guardar en Firestore)
  Map<String, dynamic> toMap() {
    return {
      'alumnoId': alumnoId,
      'asistencia': asistencia,
      'fecha': fecha,
      'hora': hora,
      'motivo': motivo,
      'psicologoId': psicologoId,
    };
  }

  factory Cita.fromFirestore(Map<String, dynamic> map) {
    return Cita(
      alumnoId: map['alumnoId'],
      asistencia: map['asistencia'],
      fecha: map['fecha'],
      hora: map['hora'],
      motivo: map['motivo'],
      psicologoId: map['psicologoId'],
    );
  }
}
