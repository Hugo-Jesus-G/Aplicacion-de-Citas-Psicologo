import 'package:flutter/material.dart';
import 'package:proyecto/alumno.dart';
import 'package:proyecto/inicio.dart';
import 'package:proyecto/obtenerDatos.dart';

class Perfil extends StatefulWidget {
  final String username;
  Perfil({required this.username});

  @override
  _PerfilState createState() => _PerfilState();

}

class _PerfilState extends State<Perfil> {
  Alumno? alumno;

  @override
  void initState() {
    super.initState();
    obtenerAlumno();
  }

  Future<void> obtenerAlumno() async {
    alumno = await obtenerAlumnoPorCorreo(widget.username);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Nombre: ${alumno?.nombre}'),
            Text('Correo: ${alumno?.correo}'),
            Text('Teléfono: ${alumno?.telefono}'),
            Text('Matrícula: ${alumno?.matricula}'),
            //regrsar a la pantalla de inicio
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,   MaterialPageRoute(builder: (context) => Inicio(username: alumno?.nombre ?? '')),
);
              },
              child: Text('Regresar'),
            ),
          ],
        ),
      ),
      
      
    );
  }
}