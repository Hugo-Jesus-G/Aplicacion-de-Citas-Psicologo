class Alumno {
  String id;
  String nombre;
  String correo;
  String telefono;
  String matricula;

  Alumno({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.matricula,
  });

  // Factory para crear un Alumno desde un Map de Firestore
  factory Alumno.fromMap(String id, Map<String, dynamic> data) {
    return Alumno(
      id: id, // Asignar el ID del documento
      nombre: data['nombre'] ?? '',
      correo: data['correo'] ?? '',
      telefono: data['telefono'] ?? '',
      matricula: data['matricula'] ?? '',
    );
  }
}
