import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/Modelos/psicologo.dart'; // Asegúrate de que la ruta sea correcta

class PerfilPsicologo extends StatefulWidget {
  @override
  _PerfilPsicologoState createState() => _PerfilPsicologoState();
}

class _PerfilPsicologoState extends State<PerfilPsicologo> {
  Psicologo? psicologo;

  @override
  void initState() {
    super.initState();
    fetchPsicologoData();
  }

  Future<void> fetchPsicologoData() async {
    final uid = FirebaseAuth
        .instance.currentUser?.uid; // Obtiene el UID del usuario autenticado

    if (uid != null) {
      try {
        // Consulta Firestore
        final doc = await FirebaseFirestore.instance
            .collection(
                'psicologos') // Cambia 'psicologos' si tu colección tiene otro nombre
            .doc(uid)
            .get();

        if (doc.exists) {
          setState(() {
            psicologo = Psicologo.fromFirestore(doc.data()!);
          });
        } else {
          setState(() {
            psicologo = null; // Maneja el caso donde no hay datos
          });
        }
      } catch (e) {
        // Manejar errores en la consulta
        print('Error al obtener datos: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil Psicólogo'),
      ),
      body: Center(
        child: psicologo != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Nombre: ${psicologo!.nombre}'),
                  Text('Correo: ${psicologo!.correo}'),
                  Text('Teléfono: ${psicologo!.telefono}'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Regresar'),
                  ),
                ],
              )
            : CircularProgressIndicator(), // Muestra un indicador de carga mientras se obtienen los datos
      ),
    );
  }
}
