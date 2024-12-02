import 'package:flutter/material.dart';
import 'package:proyecto/Modelos/alumno.dart';
import 'package:proyecto/firebase/consultas.dart';

class BienvenidaPsico extends StatefulWidget {
  const BienvenidaPsico({super.key});

  @override
  _BienvenidaPsicoState createState() => _BienvenidaPsicoState();
}

class _BienvenidaPsicoState extends State<BienvenidaPsico> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.05,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/gifts/emoji.gif',
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.3,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: screenHeight * 0.03),
                FutureBuilder<String>(
                  future: Consultas().getNombre(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Text(
                      '¡Bienvenid@ ${snapshot.data}!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                    child: Column(
                      children: [
                        Text(
                          "Recuerda:\n \"Verificar los datos del Paciente.\"\n ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 216, 22, 22),
                          ),
                        ),
                        Text("\"Marcar la Asistencia del Paciente.\"",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 23, 62, 168),
                            )),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
