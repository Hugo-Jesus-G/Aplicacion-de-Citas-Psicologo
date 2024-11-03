import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/alumno.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  Alumno? alumno;

  @override
  void initState() {
    super.initState();
    fetchAlumnoData();
  }

  Future<void> fetchAlumnoData() async {
    final uid = FirebaseAuth
        .instance.currentUser?.uid; // Obtiene el UID del usuario autenticado

    if (uid != null) {
      try {
        // Consulta Firestore
        final doc = await FirebaseFirestore.instance
            .collection('alumnos')
            .doc(uid)
            .get();

        if (doc.exists) {
          setState(() {
            alumno = Alumno.fromFirestore(doc.data()!);
          });
        } else {
          setState(() {
            alumno = null; // Aquí puedes manejar el caso donde no hay datos
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
        title: Text('Perfil'),
      ),
      body: Center(
        child: alumno != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Nombre: ${alumno!.nombre}'),
                  Text('Correo: ${alumno!.correo}'),
                  Text('Teléfono: ${alumno!.telefono}'),
                  Text('Matrícula: ${alumno!.matricula}'),
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
