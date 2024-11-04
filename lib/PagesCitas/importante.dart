import 'dart:math';

import 'package:flutter/material.dart';

class importante extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Aviso Importante',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              SizedBox(height: 20),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• Recuerda agenda tu cita con anticipación.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• Si necesitas cancelar alguna de tus citas, hazlo con al menos 24 horas de anticipación De lo contrario, se te considerará como falta y posible penalización',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '•24 hrs antes de tu cita ya no podras editarla ni cancelarla',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• Recuerda serr puntual a tu cita.',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '• Si tienes alguna duda, comunícate con nosotros.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Gracias por tu comprensión.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
