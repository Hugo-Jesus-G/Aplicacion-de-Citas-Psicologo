import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/Mensajes/mensajes.dart';
import 'package:proyecto/firebase/consultas.dart';
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

  List<String> _motivosList = []; // Lista de motivos
  List<String> _horasList = []; // Lista de horas

  @override
  void initState() {
    super.initState();
    _obtenerMotivos();
    _obtenerHoras();
  }

  Future<void> _obtenerMotivos() async {
    List<String> motivos = await Consultas().obtenerMotivos();
    setState(() {
      _motivosList = motivos;
    });
  }

  Future<void> _obtenerHoras() async {
    List<String> horas = await Consultas().obtenerHoras();
    setState(() {
      _horasList = horas;
    });
  }

  Future<void> _crearCita() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate.weekday != DateTime.saturday &&
          _selectedDate.weekday != DateTime.sunday) {
        bool citaCreada = await Consultas().crearCita(
          motivo: _motivo,
          hora: _hora,
          fecha: _fecha,
        );

        if (citaCreada) {
          setState(() {
            _motivo = '';
            _hora = '';
            _fecha = '';
            _selectedDate = DateTime.now();
          });

          Mensajes().showSuccessDialog(context, 'Cita creada con éxito');
        } else {
          Mensajes().showErrorDialog(context, 'Error al crear la cita');
        }
      } else {
        Mensajes().showErrorDialog(
            context, 'Los fines de semana no están disponibles');
      }
    } else {
      Mensajes().showErrorDialog(context, 'Debes de llenar todos los campos');
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
    return Container(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ingresa Motivo:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _horasList.isEmpty
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      ),
                      hint: Text(
                        'Selecciona el motivo de tu cita',
                        style: TextStyle(fontSize: 16),
                      ),
                      value: _motivo.isNotEmpty ? _motivo : null,
                      onChanged: (String? valor) {
                        setState(() {
                          _motivo = valor ?? '';
                        });
                      },
                      items: _motivosList
                          .map<DropdownMenuItem<String>>((String motivo) {
                        return DropdownMenuItem<String>(
                          value: motivo,
                          child: Center(
                            child: Text(
                              motivo,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona un motivo';
                        }
                        return null;
                      },
                      dropdownColor: Color(0xFFC5E0F8),
                      borderRadius: BorderRadius.circular(20),
                      isExpanded: true,
                    ),
              SizedBox(height: 40),
              Text(
                'Selecciona Fecha:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TableCalendar(
                focusedDay: _selectedDate,
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2101, 1, 1),
                onDaySelected: _onDaySelected,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                enabledDayPredicate: (day) {
                  return day
                      .isAfter(DateTime.now().subtract(Duration(days: 1)));
                },
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
                  disabledDecoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.0),
                    shape: BoxShape.circle,
                  ),
                ),
                availableGestures: AvailableGestures.none,
              ),
              SizedBox(height: 20),
              Text(
                'Selecciona Hora:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _horasList.isEmpty
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      ),
                      hint: Text(
                        'Selecciona una hora',
                        style: TextStyle(fontSize: 16),
                      ),
                      value: _hora.isNotEmpty ? _hora : null,
                      onChanged: (String? valor) {
                        setState(() {
                          _hora = valor ?? '';
                        });
                      },
                      items: _horasList
                          .map<DropdownMenuItem<String>>((String hora) {
                        return DropdownMenuItem<String>(
                          value: hora,
                          child: Center(
                            child: Text(
                              hora,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona una hora';
                        }
                        return null;
                      },
                      dropdownColor: Color(0xFFC5E0F8),
                      borderRadius: BorderRadius.circular(20),
                      isExpanded: true,
                    ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFC5E0F8)),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                  ),
                  onPressed: _crearCita,
                  child: Text(
                    'Generar Cita',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
