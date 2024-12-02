import 'package:flutter/material.dart';
import 'package:proyecto/PagesPsico/bienvenidapsico.dart';
import 'package:proyecto/PagesPsico/consultasPsico.dart';
import 'package:proyecto/PagesPsico/pacientes.dart';
import 'package:proyecto/PagesPsico/perfilPsico.dart';
import 'package:proyecto/firebase/consultas.dart';
import 'package:proyecto/main.dart';

class InicioPsico extends StatefulWidget {
  InicioPsico({super.key});

  @override
  _InicioPsicoState createState() => _InicioPsicoState();
}

class _InicioPsicoState extends State<InicioPsico> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    BienvenidaPsico(),
    MostrarCitasPsicologo(),
    PacientesScreen(),
    PerfilPsicologo(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, // Desactiva el botón de regreso

          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          centerTitle: true,
          title: _selectedIndex == 0
              ? Text('Inicio',
                  style: TextStyle(color: Colors.black, fontSize: 30))
              : _selectedIndex == 1
                  ? Text('Citas',
                      style: TextStyle(color: Colors.black, fontSize: 30))
                  : _selectedIndex == 2
                      ? Text('Pacientes',
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
                icon: Icon(Icons.remove_red_eye),
                label: 'Citas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Pacientes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color.fromARGB(255, 12, 36, 172),
            unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
          ),
        ));
  }
}
