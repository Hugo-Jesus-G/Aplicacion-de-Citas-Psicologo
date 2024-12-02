import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto/Modelos/psicologo.dart';
import 'package:proyecto/login.dart';
import 'package:proyecto/creditos.dart';
import 'package:proyecto/firebase/consultas.dart';

class PerfilPsicologo extends StatefulWidget {
  @override
  _PerfilPsicologoState createState() => _PerfilPsicologoState();
}

class _PerfilPsicologoState extends State<PerfilPsicologo> {
  Psicologo? psicologo;

  @override
  void initState() {
    super.initState();
    _infoPsicologo();
  }

  Future<void> _infoPsicologo() async {
    final fetchedPsicologo = await Consultas().fetchPsicologoData();
    setState(() {
      psicologo = fetchedPsicologo;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _logout,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 247, 1, 1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: psicologo != null
            ? LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 40),
                        Center(
                          child: Image.asset(
                            "assets/images/person.png",
                            width: constraints.maxWidth * 0.3,
                            height: constraints.maxWidth * 0.3,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Nombre: ${psicologo!.nombre}',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Correo: ${psicologo!.correo}',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Teléfono: ${psicologo!.telefono}',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.05,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text("Especialidad: ${psicologo!.especialidad}",
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.05,
                              fontWeight: FontWeight.w900,
                            )),
                        SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFC5E0F8),
                            side: BorderSide(color: Colors.black),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Creditos(),
                              ),
                            );
                          },
                          child: Text(
                            'Acerca de la aplicación',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
