import 'package:flutter/material.dart';
import 'package:proyecto/Modelos/alumno.dart';
import 'package:proyecto/creditos.dart';
import 'package:proyecto/firebase/consultas.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  Alumno? alumno;

  @override
  void initState() {
    super.initState();
    _infoAlumno();
  }

  Future<void> _infoAlumno() async {
    final fetchedAlumno = await Consultas().fetchAlumnoData();
    setState(() {
      alumno = fetchedAlumno;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: alumno != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/images/person.png",
                      width: 200, height: 200),
                  SizedBox(height: 20),
                  Text('Nombre: ${alumno!.nombre}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Correo: ${alumno!.correo}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Teléfono: ${alumno!.telefono}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  Text('Matrícula: ${alumno!.matricula}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 50),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC5E0F8),
                      side: BorderSide(color: Colors.black),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Creditos()),
                      );
                    },
                    child: Text(
                      'Acerca de la aplicación',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
