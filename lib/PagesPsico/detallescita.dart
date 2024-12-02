import 'package:flutter/material.dart';
import 'package:proyecto/Modelos/alumno.dart';
import 'package:proyecto/firebase/consultas.dart';

class DetalleCitaPage extends StatefulWidget {
  final Map<String, dynamic> cita;

  DetalleCitaPage({required this.cita});

  @override
  _DetalleCitaPageState createState() => _DetalleCitaPageState();
}

class _DetalleCitaPageState extends State<DetalleCitaPage> {
  late Future<Alumno?> alumno;
  bool? asistencia;

  Future<void> _loadUserId() async {
    alumno = Consultas().fetchAlumnoData(widget.cita['alumnoId']);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
    asistencia = widget.cita['asistencia'];
  }

  void _updateAsistencia(bool? value) {
    setState(() {
      asistencia = value;
    });
    Consultas().updateAsistencia(widget.cita['id'], value!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Detalles de la Cita',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        elevation: 4.0,
      ),
      body: FutureBuilder<Alumno?>(
        future: alumno,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los datos del alumno'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No se encontraron datos del alumno'));
          }

          final alumno = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isSmallScreen = constraints.maxWidth < 600;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Motivo: ${widget.cita['motivo']}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Fecha: ${widget.cita['fecha']}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hora: ${widget.cita['hora']}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Asistencia: ',
                            style: TextStyle(
                                fontSize: isSmallScreen ? 20 : 18,
                                color: const Color.fromARGB(255, 235, 4, 4)),
                          ),
                          Checkbox(
                            value: asistencia,
                            onChanged: _updateAsistencia,
                          ),
                          Text(
                            asistencia! ? 'Asistió' : 'No asistió',
                            style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                color: const Color.fromARGB(255, 5, 77, 233)),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Divider(color: Colors.grey[300]),
                      SizedBox(height: 16),
                      Text("Alumno",
                          style: TextStyle(
                              fontSize: isSmallScreen ? 24 : 30,
                              fontWeight: FontWeight.bold)),
                      Text(
                        'Nombre: ${alumno.nombre}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Correo: ${alumno.correo}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Teléfono: ${alumno.telefono}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
