import 'package:flutter/material.dart';
import 'package:proyecto/PagesCitas/crearCita.dart';
import 'package:proyecto/PagesCitas/importante.dart';
import 'package:proyecto/PagesCitas/mostrarCitas.dart.dart';
import 'package:proyecto/firebase/consultas.dart';
import 'package:proyecto/main.dart';
import 'package:proyecto/perfil.dart';

class Inicio extends StatefulWidget {
  Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _selectedIndex = 0; 

  // Lista de widgets que se mostrarán en el cuerpo
  final List<Widget> _widgetOptions = [
    CrearCitaPage(),
    MostrarCitas(),
    importante(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                color: const Color.fromARGB(255, 13, 155, 72),
              ),
              child: FutureBuilder<String>(
                future: Consultas().getNombre(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return Text(
                      "Bienvenido: \n${snapshot.data}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    );
                  } else {
                    return Text(
                      "Nombre no encontrado",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    );
                  }
                },
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
//cerrar sesion defirebase
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
            //informacion de contacto en el footer del menu
            ListTile(
              title: Text(
                'Infromacion del Psicologo',
                textAlign: TextAlign.center,
              ),
            ),
            //infromacion de contacto
            ListTile(
              title: Text(
                'Nombre: Psicologo',
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              title: Text(
                'Telefono: 123456789',
                textAlign: TextAlign.center,
              ),
            ),
            //soporte tecnico
            ListTile(
              title: Text(
                'Soporte Tecnico',
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              title: Text(
                'Telefono: 123456789',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Crear Cita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Consultar Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Aviso',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 12, 36, 172),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
}
