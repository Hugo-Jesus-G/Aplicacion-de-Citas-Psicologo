import 'package:flutter/material.dart';
import 'package:proyecto/alumno.dart';
import 'package:proyecto/main.dart';
import 'package:proyecto/obtenerDatos.dart';
import 'package:proyecto/perfil.dart';

class Inicio extends StatefulWidget {
  final String username; // Añadir una variable para el nombre de usuario

  const Inicio({super.key, required this.username});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  Alumno? alumno; // Variable para almacenar el objeto Alumno

  String selectedContent = 'crear';

  @override
  void initState() {
    super.initState();
    obtenerAlumno();
  }

  Future<void> obtenerAlumno() async {
    alumno = await obtenerAlumnoPorCorreo(widget.username);
    setState(() {}); 
  }

  void updateContent(String content) {
    setState(() {
      selectedContent = content;
    });
  }

  Widget getContent() {
    switch (selectedContent) {
      case 'crear':
        return Text('Contenido para Crear Cita');
      case 'consultar':
        return Text('Contenido para Consultar Citas');
      case 'cancelar':
        return Text('Contenido para Cancelar');
      default:
        return Text('Seleccione una opción');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Citas'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Muestra el nombre del alumno si no es null
                  Text(
                    "Nombre: ${alumno != null ? alumno!.nombre : 'Cargando...'}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  // Agrega más información si lo deseas
                  Text(
                    "Correo: ${alumno != null ? alumno!.correo : ''}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pushReplacement(


                  context,
                  MaterialPageRoute(
                    builder: (context) => Perfil(username: widget.username),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar Sesión'),
              onTap: () {
                // Aquí puedes agregar la lógica para cerrar sesión
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => updateContent('crear'),
                child: Text('Crear Cita'),
              ),
              ElevatedButton(
                onPressed: () => updateContent('consultar'),
                child: Text('Consultar Citas'),
              ),
              ElevatedButton(
                onPressed: () => updateContent('cancelar'),
                child: Text('Cancelar'),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: getContent(),
            ),
          ),
        ],
      ),
    );
  }
}
