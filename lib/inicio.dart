import 'package:flutter/material.dart';
import 'package:proyecto/PagesCitas/bienvenida.dart';
import 'package:proyecto/PagesCitas/crearCita.dart';
import 'package:proyecto/PagesCitas/perfil.dart';
import 'package:proyecto/PagesCitas/mostrarCitas.dart';
import 'package:proyecto/firebase/consultas.dart';
import 'package:proyecto/main.dart';

class Inicio extends StatefulWidget {
  Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    Bienvenida(),
    CrearCitaPage(),
    MostrarCitas(),
    Perfil(),
  ];

  void _selecSeccion(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          title: _selectedIndex == 0
              ? Text('Inicio',
                  style: TextStyle(color: Colors.black, fontSize: 30))
              : _selectedIndex == 1
                  ? Text('Crear Cita',
                      style: TextStyle(color: Colors.black, fontSize: 30))
                  : _selectedIndex == 2
                      ? Text('Consultar Citas',
                          style: TextStyle(color: Colors.black, fontSize: 30))
                      : Text('Perfil',
                          style: TextStyle(color: Colors.black, fontSize: 30)),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Crear Cita',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Consultar Citas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _selecSeccion,
            selectedItemColor: const Color.fromARGB(255, 12, 36, 172),
            unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
          ),
        ));
  }
}
