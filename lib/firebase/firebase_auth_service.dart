import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/inicio.dart';

class FirebaseAuthService {
  // Método para iniciar sesión
  static Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, 'Debe de llenar todos los campos.');
      return;
    }

    try {
      // Iniciar sesión con Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        _showErrorDialog(context, 'Correo o contraseña incorrectos.');
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Inicio()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorDialog(context, 'Usuario no encontrado.');
      } else if (e.code == ' ') {
        _showErrorDialog(context, 'Contraseña incorrecta.');
      } else {
        _showErrorDialog(context, 'Error desconocido ${e.message}');
      }
    } catch (e) {
      _showErrorDialog(context, 'Error desconocido $e');
    }
  }

  // Método para obtener el ID del usuario autenticado
  static String? getUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid; // Devuelve el UID del usuario actual
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Aceptar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
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
      _showErrorDialog(context, 'Debe de llenar todos los campos.');
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
        'correo': email,
        'matricula': matricula,
        'nombre': name,
        'telefono': telefono,
        'contraseña': password,
      });

      _showSuccessDialog(context, 'Usuario registrado con éxito.');
      return true;
    } on FirebaseAuthException catch (e) {
      // Manejo de excepciones específicas de Firebase
      if (e.code == 'weak-password') {
        _showErrorDialog(
            context, 'La contraseña debe tener al menos 6 caracteres.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorDialog(context, 'El correo ya está en uso.');
      } else if (e.code == 'invalid-email') {
        _showErrorDialog(context, 'Formato de correo inválido.');
      } else {
        _showErrorDialog(context, 'ocurrio un error: ${e.message}');
      }
      return false; // Indica que el registro falló
    } catch (e) {
      _showErrorDialog(context, 'ocurrio un error: $e');
      return false; // Indica que el registro falló
    }
  }

  static _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Éxito'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
