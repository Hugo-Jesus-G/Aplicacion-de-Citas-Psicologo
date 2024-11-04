import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto/Mensajes/mensajes.dart';
import 'package:proyecto/PagesCitas/mostrarCitas.dart.dart';
import 'package:table_calendar/table_calendar.dart';

class CrearCitaPage extends StatefulWidget {
  @override
  _CrearCitaPageState createState() => _CrearCitaPageState();
}

class _CrearCitaPageState extends State<CrearCitaPage> {
  final _formKey = GlobalKey<FormState>();
  String _motivo = '';
  String _fecha = '';
  String _hora = '';
  DateTime _selectedDate = DateTime.now();

  Future<void> _crearCita() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (_formKey.currentState!.validate() && userId != null) {
      try {
        await FirebaseFirestore.instance.collection('citas').add({
          'alumnoId': userId,
          'motivo': _motivo,
          'fecha': _fecha,
          'hora': _hora,
          'psicologoId': 'FL4AgbBVePXxX9ACspBZ0k4NrbD2',
        });
        Mensajes()
            .showSuccessDialog(context, "la cita se ha creado correctamente");
      } catch (e) {
        print('Error al crear la cita: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la cita')),
        );
      }
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (selectedDay.weekday != DateTime.saturday &&
        selectedDay.weekday != DateTime.sunday) {
      setState(() {
        _selectedDate = selectedDay;
        _fecha = '${selectedDay.day}/${selectedDay.month}/${selectedDay.year}';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Los fines de semana no están disponibles.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cita'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Escribe el Motivo de tu cita ',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un motivo';
                  }
                  return null;
                },
                onChanged: (value) {
                  _motivo = value;
                },
              ),
              SizedBox(height: 20),
              TableCalendar(
                focusedDay: _selectedDate,
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2101, 1, 1),
                onDaySelected: _onDaySelected,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  weekendDecoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.info,
                      color: Colors.white,
                      size: 12.0,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'No Laborables',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'Hora (HH:MM)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una hora';
                  }
                  return null;
                },
                onChanged: (value) {
                  _hora = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _crearCita,
                child: Text('Crear Cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
