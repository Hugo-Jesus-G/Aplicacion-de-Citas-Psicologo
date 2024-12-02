import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/Mensajes/mensajes.dart';
import 'package:proyecto/Modelos/alumno.dart';
import 'package:proyecto/Modelos/psicologo.dart';
import 'package:proyecto/firebase/firebase_auth_service.dart';

class Consultas {
  Future<String?> getUserId() async {
    return await FirebaseAuthService.getUserId();
  }

  Future<String> getNombre() async {
    final id = await getUserId();

    if (id != null) {
      try {
        final alumnoDoc = await FirebaseFirestore.instance
            .collection('alumnos')
            .doc(id)
            .get();

        if (alumnoDoc.exists) {
          final nombre = alumnoDoc.data()?['nombre'] ?? 'Nombre no encontrado';
          return nombre;
        }

        final psicologoDoc = await FirebaseFirestore.instance
            .collection('psicologos')
            .doc(id)
            .get();

        if (psicologoDoc.exists) {
          final nombre =
              psicologoDoc.data()?['nombre'] ?? 'Nombre no encontrado';
          return nombre;
        }

        return 'Nombre no encontrado'; // Si no se encuentra en ninguna colección
      } catch (e) {
        print('Error al obtener datos: $e');
      }
    }
    return 'Nombre no encontrado';
  }

  Stream<List<Map<String, dynamic>>> getCitasDelUsuario(String? id) async* {
    if (id != null) {
      try {
        yield* FirebaseFirestore.instance
            .collection('citas')
            .where('alumnoId', isEqualTo: id)
            .snapshots()
            .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
      } catch (e) {
        print('Error al obtener citas: $e');
        yield [];
      }
    } else {
      yield [];
    }
  }

  Future<void> eliminarCita(BuildContext context, String citaId) async {
    try {
      await FirebaseFirestore.instance.collection('citas').doc(citaId).delete();
      await Mensajes().showSuccessDialog(context, "La cita ha sido eliminada");
    } catch (e) {
      print('Error al eliminar la cita: $e');
      await Mensajes().showErrorDialog(
          context, "No se pudo eliminar la cita. Intenta nuevamente.");
    }
  }

  Future<void> editarCita(String citaId, String nuevoMotivo, String nuevaFecha,
      String nuevaHora) async {
    try {
      await FirebaseFirestore.instance.collection('citas').doc(citaId).update({
        'motivo': nuevoMotivo,
        'fecha': nuevaFecha,
        'hora': nuevaHora,
      });
      print('Cita actualizada con éxito');
    } catch (e) {
      print('Error al editar la cita: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getCitasDelPsicologoStream() {
    final psicologoId =
        getUserId(); // Suponiendo que obtienes el ID del psicólogo

    try {
      return FirebaseFirestore.instance
          .collection('citas')
          .where('psicologoId',
              isEqualTo: psicologoId) // Filtra por el psicólogo
          .snapshots() // Obtener un Stream en lugar de un Future
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Agregar el ID del documento al mapa
          return data;
        }).toList();
      });
    } catch (e) {
      print('Error al obtener citas: $e');
      return Stream.value([]); // Devuelve un stream vacío en caso de error
    }
  }

//obtener correo
  Future<String> getCorreo() async {
    final id = await FirebaseAuthService.getUserId();

    if (id != null) {
      try {
        final alumnoDoc = await FirebaseFirestore.instance
            .collection('alumnos')
            .doc(id)
            .get();

        if (alumnoDoc.exists) {
          final correo = alumnoDoc.data()?['correo'] ?? 'Correo no encontrado';
          return correo;
        }

        final psicologoDoc = await FirebaseFirestore.instance
            .collection('psicologos')
            .doc(id)
            .get();

        if (psicologoDoc.exists) {
          final correo =
              psicologoDoc.data()?['correo'] ?? 'Correo no encontrado';
          return correo;
        }

        return 'Correo no encontrado'; // Si no se encuentra en ninguna colección
      } catch (e) {
        print('Error al obtener datos: $e');
      }
    }
    return 'Correo no encontrado';
  }

  Future<Alumno> fetchAlumnoData(String uid) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('alumnos').doc(uid).get();

      if (doc.exists) {
        final data = doc.data();
        final idAlumno = data?['id'] ?? 'ID no encontrado';
        final nombre = data?['nombre'] ?? 'Nombre no encontrado';
        final correo = data?['correo'] ?? 'Correo no encontrado';
        final telefono = data?['telefono'] ?? 'Teléfono no encontrado';
        final matricula = data?['matricula'] ?? 'Matrícula no encontrada';

        return Alumno(
          id: idAlumno,
          nombre: nombre,
          correo: correo,
          telefono: telefono,
          matricula: matricula,
        );
      } else {
        return Alumno(
            id: "No encontrado",
            nombre: "No encontrado",
            correo: "No encontrado",
            telefono: "No encontrado",
            matricula: "No encontrado");
      }
    } catch (e) {
      print('Error al obtener datos: $e');
    }
    return Alumno(
        id: "No encontrado",
        nombre: "No encontrado",
        correo: "No encontrado",
        telefono: "No encontrado",
        matricula: "No encontrado");
  }

  Future<bool> crearCita({
    required String motivo,
    required String hora,
    required String fecha,
  }) async {
    final userId = await Consultas().getUserId();

    try {
      await FirebaseFirestore.instance.collection('citas').add({
        'alumnoId': userId,
        'motivo': motivo,
        'fecha': fecha,
        'hora': hora,
        'psicologoId': 'FL4AgbBVePXxX9ACspBZ0k4NrbD2',
        'asistencia': false,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // Método para obtener los motivos
  Future<List<String>> obtenerMotivos() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('motivos')
          .doc('Rb2tgoPfMh92tT9aGK0J')
          .get();

      if (snapshot.exists) {
        return List<String>.from(snapshot['motivo']);
      } else {
        return [];
      }
    } catch (e) {
      print('Error al obtener los motivos: $e');
      return [];
    }
  }

  Future<List<String>> obtenerHorasCreacion(String fechaSeleccionada) async {
    try {
      // Obtener todas las horas de la colección de horarios
      var snapshotHorarios = await FirebaseFirestore.instance
          .collection('horarios')
          .doc('NvnNKlbO3Z7md76Gw60Q')
          .get();

      if (!snapshotHorarios.exists) {
        return [];
      }

      List<String> horas = List<String>.from(snapshotHorarios['horas']);

      var snapshotCitas = await FirebaseFirestore.instance
          .collection('citas')
          .where('fecha', isEqualTo: fechaSeleccionada)
          .get();

      List horasOcupadas =
          snapshotCitas.docs.map((doc) => doc['hora']).toList();

      // Filtrar las horas disponibles (aquellas que no están ocupadas)
      List<String> horasDisponibles =
          horas.where((hora) => !horasOcupadas.contains(hora)).toList();

      return horasDisponibles;
    } catch (e) {
      print('Error al obtener las horas: $e');
      return [];
    }
  }

// Método para obtener las horas
  Future<List<String>> obtenerHorasEdit() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('horarios')
          .doc('NvnNKlbO3Z7md76Gw60Q')
          .get();

      if (snapshot.exists) {
        return List<String>.from(snapshot['horas']);
      } else {
        return [];
      }
    } catch (e) {
      print('Error al obtener las horas: $e');
      return [];
    }
  }

  Future<Psicologo?> fetchPsicologoData() async {
    try {
      String? uid = await Consultas().getUserId();
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('psicologos')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        return Psicologo.fromFirestore(snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print("Error al obtener datos del psicólogo: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCitasDelPsicologo() async {
    final psicologoId =
        await getUserId(); // Suponiendo que obtienes el ID del psicólogo

    if (psicologoId != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('citas')
            .where('psicologoId',
                isEqualTo: psicologoId) // Filtra por el psicólogo
            .get(); // Obtiene las citas

        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Agregar el ID del documento al mapa
          return data;
        }).toList(); // Convierte los documentos en una lista de mapas
      } catch (e) {
        print('Error al obtener citas: $e');
        return [];
      }
    }
    return [];
  }

  // Método para actualizar la asistencia en la base de datos
  Future<void> updateAsistencia(String citaId, bool asistencia) async {
    try {
      await FirebaseFirestore.instance.collection('citas').doc(citaId).update({
        'asistencia': asistencia,
      });
    } catch (e) {
      print('Error al actualizar la asistencia: $e');
    }
  }

  Future<bool> verificarCitaExistente(String fecha, String hora) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('citas')
          .where('fecha', isEqualTo: fecha)
          .where('hora', isEqualTo: hora)
          .get();

      return querySnapshot
          .docs.isNotEmpty; // Si hay resultados, la cita ya existe
    } catch (e) {
      print('Error al verificar cita existente: $e');
      return false; // En caso de error, asumir que no existe la cita
    }
  }
}
