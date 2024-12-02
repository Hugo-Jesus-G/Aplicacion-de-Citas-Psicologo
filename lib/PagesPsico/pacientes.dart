import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/Modelos/alumno.dart';
import 'package:proyecto/PagesPsico/historial.dart';

class PacientesScreen extends StatefulWidget {
  @override
  _PacientesScreenState createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  List<Alumno> alumnos = [];

  @override
  void initState() {
    super.initState();
    _fetchPacientes();
  }

  Future<void> _fetchPacientes() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('alumnos').get();
      List<Alumno> loadedAlumnos = [];

      for (var doc in querySnapshot.docs) {
        loadedAlumnos
            .add(Alumno.fromFirestore(doc.data() as Map<String, dynamic>));
      }

      setState(() {
        alumnos = loadedAlumnos;
      });
    } catch (e) {
      print('Error al obtener pacientes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: alumnos.isEmpty
          ? Center(child: Text('No hay citas regitradas.'))
          : ListView.builder(
              itemCount: alumnos.length,
              itemBuilder: (context, index) {
                final alumno = alumnos[index];
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      alumno.nombre,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // matricula
                            'Matrícula: ${alumno.matricula}',
                            style: TextStyle(
                                fontSize: 18,
                                color: const Color.fromARGB(255, 9, 48, 224),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Teléfono: ${alumno.telefono}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            'Correo: ${alumno.correo}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blueGrey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HistorialCitasScreen(alumno: alumno),
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
