import 'package:flutter/material.dart';
import 'package:proyecto/firebase/consultas.dart';

class MostrarCitasPsicologo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Citas del Psicólogo'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Consultas().getCitasDelPsicologo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las citas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay citas programadas.'));
          }

          final citas = snapshot.data!;
          return ListView.builder(
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              return ListTile(
                title: Text('Motivo: ${cita['motivo']}'),
                subtitle:
                    Text('Fecha: ${cita['fecha']} - Hora: ${cita['hora']}'),
              );
            },
          );
        },
      ),
    );
  }
}
