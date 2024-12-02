class Alumno {
  final String id;
  final String nombre;
  final String correo;
  final String telefono;
  final String matricula;

  Alumno({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.matricula,
  });

  factory Alumno.fromFirestore(Map<String, dynamic> data) {
    return Alumno(
      id: data['id'] ?? '',
      nombre: data['nombre'] ?? '',
      correo: data['correo'] ?? '',
      telefono: data['telefono'] ?? '',
      matricula: data['matricula'] ?? '',
    );
  }
}
