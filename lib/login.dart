import 'package:flutter/material.dart';
import 'package:proyecto/firebase/firebase_auth_service.dart';
import 'package:proyecto/registro.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  bool _obscureText = true; // Controla la visibilidad de la contraseña
  TextEditingController passController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
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
                backgroundColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 49, 39, 199),
                ),
              ),
              onPressed: () async {
                FirebaseAuthService.loginUser(
                  email: emailController.text,
                  password: passController.text,
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
