import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/Mensajes/mensajes.dart';
import 'package:proyecto/Modelos/alumno.dart';
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

  Future<Alumno> fetchAlumnoData() async {
    final uid = await Consultas().getUserId();

    if (uid != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('alumnos')
            .doc(uid)
            .get();

        if (doc.exists) {
          final data = doc.data();
          final nombre = data?['nombre'] ?? 'Nombre no encontrado';
          final correo = data?['correo'] ?? 'Correo no encontrado';
          final telefono = data?['telefono'] ?? 'Teléfono no encontrado';
          final matricula = data?['matricula'] ?? 'Matrícula no encontrada';

          return Alumno(
            nombre: nombre,
            correo: correo,
            telefono: telefono,
            matricula: matricula,
          );
        } else {
          return Alumno(
              nombre: "No encontrado",
              correo: "No encontrado",
              telefono: "No encontrado",
              matricula: "No encontrado");
        }
      } catch (e) {
        print('Error al obtener datos: $e');
      }
    }
    return Alumno(
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

// Método para obtener las horas
  Future<List<String>> obtenerHoras() async {
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
}
