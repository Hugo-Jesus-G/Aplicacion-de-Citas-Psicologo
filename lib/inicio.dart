import 'package:flutter/material.dart';
import 'package:proyecto/firebase/firebase_auth_service.dart';
import 'package:proyecto/main.dart';
import 'package:proyecto/perfil.dart';

class Inicio extends StatefulWidget {
  Inicio({super.key});

  String? uid = FirebaseAuthService.getUserId();

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  String selectedContent = 'crear';

  @override
  void initState() {
    super.initState();
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
                    "Nombre: ${widget.uid}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  // Agrega más información si lo deseas
                  Text(
                    "Nombre: ${widget.uid}",
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Perfil()),
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
