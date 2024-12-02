class Psicologo {
  final String nombre;
  final String correo;
  final String telefono;
  final String especialidad;

  Psicologo({
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.especialidad,
  });

  factory Psicologo.fromFirestore(Map<String, dynamic> data) {
    return Psicologo(
      nombre: data['nombre'] ?? '',
      correo: data['correo'] ?? '',
      telefono: data['telefono'] ?? '',
      especialidad: data['especialidad'] ?? '',
    );
  }
}
