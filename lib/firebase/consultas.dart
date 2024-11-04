import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/Mensajes/mensajes.dart';
import 'package:proyecto/firebase/firebase_auth_service.dart';

class Consultas {
  // Cambiar la forma en que se obtiene el id
  Future<String?> getUserId() async {
    return await FirebaseAuthService.getUserId();
  }

  Future<String> getNombre() async {
    final id = await getUserId();

    if (id != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('alumnos')
            .doc(id)
            .get();

        if (doc.exists) {
          final nombre = doc.data()?['nombre'] ?? 'Nombre no encontrado';
          return nombre;
        } else {
          return 'Nombre no encontrado';
        }
      } catch (e) {
        print('Error al obtener datos: ');
      }
    }
    return 'Nombre no encontrado';
  }

  Stream<List<Map<String, dynamic>>> getCitasDelUsuario() async* {
    final id = await getUserId();

    if (id != null) {
      try {
        // Escucha los cambios en la colección 'citas'
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
}
