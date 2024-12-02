import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto/PagesPsico/detallescita.dart';
import 'package:proyecto/firebase/consultas.dart';

class MostrarCitasPsicologo extends StatefulWidget {
  @override
  _MostrarCitasPsicologoState createState() => _MostrarCitasPsicologoState();
}

class _MostrarCitasPsicologoState extends State<MostrarCitasPsicologo> {
  String filtro = 'hoy';

  void cambiarFiltro(String nuevoFiltro) {
    setState(() {
      filtro = nuevoFiltro;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: filtro == 'hoy'
                        ? Colors.blue
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () => cambiarFiltro('hoy'),
                  child: Text(' Hoy',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 250, 250, 250))),
                ),
                SizedBox(width: 0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: filtro == 'pendientes'
                        ? Colors.blue
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () => cambiarFiltro('pendientes'),
                  child: Text(' Pendientes',
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: filtro == 'vencidas'
                        ? Colors.blue
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                  onPressed: () => cambiarFiltro('vencidas'),
                  child: Text(' Vencidas',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255))),
                ),
              ],
            ),
          ),
          // Contenido de las citas filtradas
          Expanded(
            child: CitasFiltradas(filtro: filtro),
          ),
        ],
      ),
    );
  }
}

class CitasFiltradas extends StatelessWidget {
  final String filtro;

  CitasFiltradas({required this.filtro});

  DateTime? parseCitaDateTime(String fecha, String hora) {
    try {
      return DateFormat('dd/MM/yyyy HH:mm').parse('$fecha $hora');
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
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

        final citasFiltradas = citas.where((cita) {
          DateTime? citaDateTime =
              parseCitaDateTime(cita['fecha'] ?? '', cita['hora'] ?? '');
          if (citaDateTime == null) return false;

          bool isExpired = citaDateTime.isBefore(DateTime.now());
          bool isToday = DateFormat('dd/MM/yyyy').format(citaDateTime) ==
              DateFormat('dd/MM/yyyy').format(DateTime.now());

          if (filtro == 'hoy') {
            return isToday; // Solo citas hoy
          } else if (filtro == 'pendientes') {
            return !isExpired;
          } else {
            return isExpired;
          }
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
              filtro == 'hoy'
                  ? 'No tienes citas hoy.'
                  : filtro == 'pendientes'
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
            return Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  'Motivo: ${cita['motivo']}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 600 ? 18 : 16,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fecha: ${cita['fecha']}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      Text(
                        'Hora: ${cita['hora']}',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                leading: Icon(
                  Icons.event,
                  color: Colors.blueGrey,
                  size: MediaQuery.of(context).size.width > 600 ? 30 : 25,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blueGrey,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetalleCitaPage(cita: cita),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
