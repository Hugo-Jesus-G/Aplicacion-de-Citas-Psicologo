import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto/PagesCitas/editar.dart';
import 'package:proyecto/firebase/consultas.dart';

class MostrarCitas extends StatefulWidget {
  @override
  _MostrarCitasState createState() => _MostrarCitasState();
}

class _MostrarCitasState extends State<MostrarCitas> {
  bool mostrarPendientes = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 115, 218, 178),
                side: BorderSide(color: Colors.black),
                elevation: 2,
              ),
              onPressed: () {
                setState(() {
                  mostrarPendientes = true;
                });
              },
              child: Text('Citas Pendientes',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 240, 105, 146),
                side: BorderSide(
                  color: Colors.black,
                ),
                elevation: 2,
              ),
              onPressed: () {
                setState(() {
                  mostrarPendientes = false;
                });
              },
              child: Text('Citas Vencidas',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
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

              final citasFiltradas = citas.where((cita) {
                String hora = cita['hora'];
                if (hora.contains('-')) {
                  hora = hora.split('-')[1];
                }

                DateTime citaDateTime;
                try {
                  citaDateTime = DateFormat('dd/MM/yyyy HH:mm')
                      .parse('${cita['fecha']} $hora', true);
                } catch (e) {
                  return false;
                }

                bool isExpired = citaDateTime.isBefore(DateTime.now());
                return mostrarPendientes ? !isExpired : isExpired;
              }).toList();

              citasFiltradas.sort((a, b) {
                DateTime citaA = DateFormat('dd/MM/yyyy HH:mm')
                    .parse('${a['fecha']} ${a['hora']}');
                DateTime citaB = DateFormat('dd/MM/yyyy HH:mm')
                    .parse('${b['fecha']} ${b['hora']}');
                return citaA.compareTo(citaB);
              });

              if (citasFiltradas.isEmpty) {
                return Center(
                  child: Text(
                    mostrarPendientes
                        ? 'No tienes citas pendientes.'
                        : 'No tienes citas vencidas.',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(15),
                itemCount: citasFiltradas.length,
                itemBuilder: (context, index) {
                  final cita = citasFiltradas[index];
                  bool editaryeliminar = false;

                  DateTime citaDateTime = DateFormat('dd/MM/yyyy HH:mm')
                      .parse('${cita['fecha']} ${cita['hora']}');

                  bool isExpired = citaDateTime.isBefore(DateTime.now());

                  String horaInicio = cita['hora'].split('-')[0];
                  // Verificar si faltan 24 horas para la cita
                  DateTime citaActual = DateFormat('dd/MM/yyyy HH:mm')
                      .parse('${cita['fecha']} $horaInicio');
                  DateTime fechaActual = DateTime.now();
                  final diferencia = citaActual.difference(fechaActual).inHours;
                  if (diferencia <= 24) {
                    editaryeliminar = true;
                  }

                  return Opacity(
                    opacity: isExpired ? 1.0 : 1.0,
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
                            if (!editaryeliminar)
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: const Color.fromARGB(
                                        255, 11, 115, 163)),
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
                            if (!editaryeliminar || isExpired)
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
        ),
      ],
    );
  }
}
