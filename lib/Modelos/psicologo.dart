class Psicologo {
  final String nombre;
  final String correo;
  final String telefono;
  final Map<String, List<String>> disponibilidad;

  Psicologo({
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.disponibilidad,
  });

  factory Psicologo.fromFirestore(Map<String, dynamic> data) {
    return Psicologo(
      nombre: data['nombre'] ?? '',
      correo: data['correo'] ?? '',
      telefono: data['telefono'] ?? '',
      disponibilidad:
          Map<String, List<String>>.from(data['disponibilidad'] ?? {}),
    );
  }
}
