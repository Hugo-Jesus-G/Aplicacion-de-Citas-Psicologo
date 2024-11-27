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
        // Verificar en la colección de alumnos
        final alumnoDoc = await FirebaseFirestore.instance
            .collection('alumnos')
            .doc(id)
            .get();

        if (alumnoDoc.exists) {
          final nombre = alumnoDoc.data()?['nombre'] ?? 'Nombre no encontrado';
          return nombre;
        }

        // Verificar en la colección de psicólogos
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

//obtener citas generales del psciologo
  Future<List<Map<String, dynamic>>> getCitasDelPsicologo() async {
    final psicologoId = await getUserId();

    if (psicologoId != null) {
      try {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('citas')
            .where('psicologoId',
                isEqualTo:
                    psicologoId) // Suponiendo que este es el campo en la colección 'citas'
            .get();

        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Agregar el ID del documento al mapa
          return data;
        }).toList();
      } catch (e) {
        print('Error al obtener citas: $e');
        return [];
      }
    }
    return [];
  }
}
