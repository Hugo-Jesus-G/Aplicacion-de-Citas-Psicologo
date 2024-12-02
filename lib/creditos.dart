import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/Modelos/alumno.dart';
import 'package:proyecto/firebase/consultas.dart';

class Creditos extends StatefulWidget {
  @override
  _CreditosState createState() => _CreditosState();
}

class _CreditosState extends State<Creditos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Créditos"),
        backgroundColor: Color(0xFFC5E0F8),
      ),
      body: Center(
        child: Image.asset(
          "assets/gifts/creditos.gif",
          height: 700,
          width: 700,
        ),
      ),
    );
  }
}
