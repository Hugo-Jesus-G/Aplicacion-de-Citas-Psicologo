import 'package:flutter/material.dart';
import 'package:proyecto/main.dart';

class Inicio extends StatefulWidget {
  final String username; // Añadir una variable para el nombre de usuario

  const Inicio({super.key, required this.username});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bienvenido, ${widget.username}', // Mostrar el nombre del usuario

              style: TextStyle(fontSize: 20),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    iconColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 172, 21, 21)),
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 49, 39, 199))),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text(
                  "Cerrar Sesión",
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
