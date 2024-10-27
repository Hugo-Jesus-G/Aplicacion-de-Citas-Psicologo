import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto/main.dart';

class HomeRegistro extends StatefulWidget {
  const HomeRegistro({super.key});

  @override
  _HomeRegistroState createState() => _HomeRegistroState();
}

class _HomeRegistroState extends State<HomeRegistro> {
  Future<FirebaseApp> _inicializacionFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _inicializacionFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return RegistroScreen();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // Método para agregar usuarios a Firestore
  Future<void> registrarUser({
    required String name,
    required String email,
    required String matricula,
    required String telefono,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Verificar si los campos están vacíos
    if (email.isEmpty ||
        matricula.isEmpty ||
        name.isEmpty ||
        telefono.isEmpty ||
        password.isEmpty) {
      _showErrorDialog(context, 'Debe de llenar todos los campos.');
      return;
    }

    try {
      // Guardar datos del usuario en Firestore
      await firestore.collection('alumnos').add({
        'correo': email,
        'matricula': matricula,
        'nombre': name,
        'telefono': telefono,
        'contraseña': password,
      });

      // Mostrar un mensaje de éxito
      _showSuccessDialog(context, 'Usuario registrado con éxito.');
    } catch (e) {
      // Manejo de errores
      _showErrorDialog(context, 'Ocurrió un error: $e');
    }
  }

  // Métodos para mostrar diálogos
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

   void _showSuccessDialog(BuildContext context, String message) {
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
                //limpiar campos
                emailController.clear();
                nameController.clear();
                numberController.clear();
                telefonoController.clear();
                passwordController.clear();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
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
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text(
              "Registro",
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person, color: Colors.black),
                hintText: "Ingresa tu nombre",
                labelText: "Nombre de Usuario",
              ),
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
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person, color: Colors.black),
                hintText: "Matrícula",
                labelText: "Matrícula",
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: telefonoController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone, color: Colors.black),
                hintText: "Ingresa tu número de teléfono",
                labelText: "Número de teléfono",
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Colors.black),
                hintText: "Ingresa tu Contraseña",
                labelText: "Contraseña",
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("¿Ya tienes una cuenta?"),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Text("Inicia Sesión"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 49, 39, 199),
                  ),
                ),
                onPressed: () async {
                  await registrarUser(
                    name: nameController.text,
                    email: emailController.text,
                    matricula: numberController.text,
                    telefono: telefonoController.text,
                    password: passwordController.text,
                    context: context,
                  );
                },
                child: Text(
                  "Registrarse",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
