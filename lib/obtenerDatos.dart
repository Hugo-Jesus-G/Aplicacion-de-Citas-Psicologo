import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/alumno.dart';

Future<Alumno?> obtenerAlumnoPorCorreo(String correo) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot snapshot = await firestore
        .collection('alumnos')
        .where('correo', isEqualTo: correo)
        .get();

    if (snapshot.docs.isNotEmpty) {
      var datosAlumno = snapshot.docs.first.data() as Map<String, dynamic>;
      String id = snapshot.docs.first.id; // Obtener el ID del documento
      return Alumno.fromMap(id, datosAlumno);
    } else {
      print("No se encontró ningún alumno con ese correo.");
      return null;
    }
  } catch (e) {
    print("Error al obtener la información del alumno: $e");
    return null;
  }
}
