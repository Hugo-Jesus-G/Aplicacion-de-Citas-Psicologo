class Alumno {
  final String nombre;
  final String correo;
  final String telefono;
  final String matricula;

  Alumno({
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.matricula,
  });

  factory Alumno.fromFirestore(Map<String, dynamic> data) {
    return Alumno(
      nombre: data['nombre'] ?? '',
      correo: data['correo'] ?? '',
      telefono: data['telefono'] ?? '',
      matricula: data['matricula'] ?? '',
    );
  }
}
