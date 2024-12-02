import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/Mensajes/mensajes.dart';
import 'package:proyecto/PagesPsico/InicioPsico.dart';
import 'package:proyecto/inicio.dart';

class FirebaseAuthService {
  // Método para iniciar sesión
  static Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      Mensajes().showErrorDialog(context, 'Debe de llenar todos los campos.');
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        Mensajes().showErrorDialog(context, 'Correo o contraseña incorrectos.');
        return;
      }

      final userId = userCredential.user!.uid;

      // Verificar si el usuario es un alumno o psicólogo
      DocumentSnapshot alumnoDoc = await FirebaseFirestore.instance
          .collection('alumnos')
          .doc(userId)
          .get();
      DocumentSnapshot psicologoDoc = await FirebaseFirestore.instance
          .collection('psicologos')
          .doc(userId)
          .get();

      if (alumnoDoc.exists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Inicio()),
        );
      } else if (psicologoDoc.exists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => InicioPsico()),
        );
      }
    } catch (e) {
      Mensajes().showErrorDialog(context, 'Correo o contraseña incorrectos.');
    }
  }

  static String? getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Método para registrar un nuevo usuario
  static Future<bool> registerUser({
    required String name,
    required String email,
    required String matricula,
    required String telefono,
    required String password,
    required BuildContext context,
  }) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      Mensajes().showErrorDialog(context, 'Debe de llenar todos los campos.');
      return false;
    }

    try {
      // Crear usuario en Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtener el UID del nuevo usuario
      String uid = userCredential.user!.uid;

      // Guardar el usuario en Firestore
      await FirebaseFirestore.instance.collection('alumnos').doc(uid).set({
        'id': uid,
        'correo': email,
        'matricula': matricula,
        'nombre': name,
        'telefono': telefono,
        'contraseña': password,
      });

      Mensajes().showSuccessDialog(context, 'Usuario registrado con éxito.');
      return true;
    } on FirebaseAuthException catch (e) {
      // Manejo de excepciones específicas de Firebase
      if (e.code == 'weak-password') {
        Mensajes().showErrorDialog(
            context, 'La contraseña debe tener al menos 6 caracteres.');
      } else if (e.code == 'email-already-in-use') {
        Mensajes().showErrorDialog(context, 'El correo ya está en uso.');
      } else if (e.code == 'invalid-email') {
        Mensajes().showErrorDialog(context, 'Formato de correo inválido.');
      } else {
        Mensajes().showErrorDialog(context, 'ocurrio un error: ${e.message}');
      }
      return false; // Indica que el registro falló
    } catch (e) {
      Mensajes().showErrorDialog(context, 'ocurrio un error: $e');
      return false; // Indica que el registro falló
    }
  }
}
