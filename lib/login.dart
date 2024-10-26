import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/inicio.dart';
import 'package:proyecto/registro.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  // Función para iniciar sesión
  static Future<void> loginUser({
    required String email,
    required String pass,
    required BuildContext context,
  }) async {
    // Verificar si los campos están vacíos
    if (email.isEmpty || pass.isEmpty) {
      _showErrorDialog(context, 'Debe de llenar todos los campos.');
      return;
    }

    try {
      // Consultar Firestore para encontrar el usuario
      final userSnapshot = await FirebaseFirestore.instance
          .collection('alumnos')
          .where('correo', isEqualTo: email)
          .where('contraseña', isEqualTo: pass)
          .get();

      if (userSnapshot.docs.isEmpty) {
        _showErrorDialog(context, 'Correo o contraseña incorrectos.');
      } else {
        // Usuario encontrado, redirigir a la pantalla de inicio
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Inicio(username: email)));
      }
    } catch (e) {
      _showErrorDialog(context, 'Error desconocido: $e');
    }
  }

  // Método para mostrar un diálogo de error
  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
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

  TextEditingController emailController = TextEditingController();
  bool _obscureText = true; // Controla la visibilidad de la contraseña
  TextEditingController passController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText; // Cambia el estado de visibilidad
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Center(
              child: Text(
                "PSICO CITA",
                style: TextStyle(
                  color: const Color.fromARGB(255, 34, 31, 184),
                  fontSize: screenWidth * 0.08, // Tamaño responsivo
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Text(
            "Iniciar Sesión",
            style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email, color: Colors.black),
              hintText: "Ingresa tu correo",
              labelText: "Correo",
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: passController,
            obscureText: _obscureText,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock, color: Colors.black),
              hintText: "Ingresa tu Contraseña",
              labelText: "Contraseña",
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("¿No tienes cuenta?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeRegistro()));
                },
                child: Text("Regístrate"),
              ),
            ],
          ),
          SizedBox(height: 30),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 49, 39, 199),
                ),
              ),
              onPressed: () async {
                await loginUser(
                  email: emailController.text,
                  pass: passController.text,
                  context: context,
                );
              },
              child: Text(
                "Iniciar Sesión",
                style: TextStyle(
                    fontSize: screenWidth * 0.05, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
