import 'package:flutter/material.dart';
import 'package:proyecto/Modelos/alumno.dart';
import 'package:proyecto/firebase/consultas.dart';

class Bienvenida extends StatefulWidget {
  Bienvenida({super.key});

  @override
  _BienvenidaState createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Image.asset(
                'assets/gifts/emoji.gif',
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
            ),
            FutureBuilder<String>(
              future: Consultas().getNombre(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return Text(
                  '¡Bienvenid@ ${snapshot.data}!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: Text(
                "\"Recuerda: 24 horas antes de tu cita agendada, no será posible cancelarla ni realizar modificaciones.\"",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 216, 22, 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
