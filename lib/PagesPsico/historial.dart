import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto/Modelos/alumno.dart';
import 'package:proyecto/firebase/consultas.dart';

class HistorialCitasScreen extends StatefulWidget {
  final Alumno alumno;

  HistorialCitasScreen({required this.alumno});

  @override
  _HistorialCitasScreenState createState() => _HistorialCitasScreenState();
}

class _HistorialCitasScreenState extends State<HistorialCitasScreen> {
  bool mostrarPendientes = true;
  String? id;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    id = await Consultas().getUserId();
    setState(() {
      id;
    });
  }

  DateTime? parseCitaDateTime(String fecha, String hora) {
    try {
      return DateFormat('dd/MM/yyyy HH:mm').parse('$fecha $hora');
    } catch (e) {
      return null; // Manejo de error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Regresar"),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
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
                child: Text(
                  'Citas Pendientes',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 114, 211, 4),
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
                child: Text(
                  'Historial',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: Consultas().getCitasDelUsuario(widget.alumno.id),
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
                  String hora = cita['hora'] ?? '';
                  if (hora.contains('-')) {
                    hora = hora.split('-')[1];
                  }

                  DateTime? citaDateTime = parseCitaDateTime(
                    cita['fecha'] ?? '',
                    hora,
                  );

                  if (citaDateTime == null) return false;

                  bool isExpired = citaDateTime.isBefore(DateTime.now());
                  return mostrarPendientes ? !isExpired : isExpired;
                }).toList();

                citasFiltradas.sort((a, b) {
                  DateTime citaA =
                      parseCitaDateTime(a['fecha'] ?? '', a['hora'] ?? '') ??
                          DateTime.now();
                  DateTime citaB =
                      parseCitaDateTime(b['fecha'] ?? '', b['hora'] ?? '') ??
                          DateTime.now();
                  return citaA.compareTo(citaB);
                });

                if (citasFiltradas.isEmpty) {
                  return Center(
                    child: Text(
                      mostrarPendientes
                          ? 'No tiene citas pendientes.'
                          : 'No tiene citas vencidas.',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: citasFiltradas.length,
                  itemBuilder: (context, index) {
                    final cita = citasFiltradas[index];

                    DateTime? citaDateTime = parseCitaDateTime(
                      cita['fecha'] ?? '',
                      cita['hora'] ?? '',
                    );

                    bool isExpired = citaDateTime != null &&
                        citaDateTime.isBefore(DateTime.now());

                    final String motivo = cita['motivo'] ?? 'Sin motivo';
                    final String fecha =
                        cita['fecha'] ?? 'Fecha no especificada';
                    final String hora = cita['hora'] ?? 'Hora no especificada';

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text(
                          'Motivo: $motivo',
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 105, 12, 180),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Fecha: $fecha',
                                style: TextStyle(fontSize: 16)),
                            Text('Hora: $hora', style: TextStyle(fontSize: 16)),
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
                        trailing: isExpired
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    cita['asistencia']
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: cita['asistencia']
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  SizedBox(
                                      height:
                                          4), // Espacio entre el ícono y el texto
                                  Text(
                                    cita['asistencia']
                                        ? 'Asistió'
                                        : 'NO asistió',
                                    style: TextStyle(
                                      color: cita['asistencia']
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Icon(Icons.timer, color: Colors.blue),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
