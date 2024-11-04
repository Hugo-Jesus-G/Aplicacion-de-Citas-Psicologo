import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto/PagesCitas/editar.dart';
import 'package:proyecto/firebase/consultas.dart';

class MostrarCitas extends StatelessWidget {
  MostrarCitas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Citas'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Consultas().getCitasDelUsuario(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las citas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tienes citas programadas.'));
          }

          final citas = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(15),
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];

              // Convertir la fecha y hora de la cita a un objeto DateTime
              DateTime citaDateTime = DateFormat('dd/MM/yyyy HH:mm')
                  .parse('${cita['fecha']} ${cita['hora']}');

              // Verificar si la cita ya ha pasado
              bool isExpired = citaDateTime.isBefore(DateTime.now());

              return Opacity(
                opacity: isExpired ? 0.5 : 1.0,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      'Motivo: ${cita['motivo']}',
                      style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 105, 12, 180),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fecha: ${cita['fecha']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Hora: ${cita['hora']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          isExpired ? 'Cita vencida' : 'Cita pendiente',
                          style: TextStyle(
                            color: isExpired ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isExpired)
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: const Color.fromARGB(255, 11, 115, 163)),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditarCitaPage(
                                    citaId: cita['id'],
                                    motivo: cita['motivo'],
                                    fecha: cita['fecha'],
                                    hora: cita['hora'],
                                  ),
                                ),
                              );
                            },
                          ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await Consultas()
                                  .eliminarCita(context, cita['id']);
                            } catch (e) {
                              print('Error al eliminar la cita: $e');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<String?> mostrarDialogoEdicion(
      BuildContext context, String titulo, String valorActual) async {
    TextEditingController controlador =
        TextEditingController(text: valorActual);

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: TextField(
            controller: controlador,
            decoration: InputDecoration(hintText: 'Ingrese $titulo'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controlador.text);
              },
              child: Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar sin guardar
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
