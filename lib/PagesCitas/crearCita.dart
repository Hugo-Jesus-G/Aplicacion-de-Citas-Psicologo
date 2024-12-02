import 'package:flutter/material.dart';
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
  DateTime? _selectedDate; // Cambia a DateTime? para permitir null

  List<String> _motivosList = [];
  List<String> _horasList = [];

  @override
  void initState() {
    super.initState();
    _obtenerMotivos();
    _obtenerHoras(_fecha);
  }

  Future<void> _obtenerMotivos() async {
    List<String> motivos = await Consultas().obtenerMotivos();
    setState(() {
      _motivosList = motivos;
    });
  }

  Future<void> _obtenerHoras(String fecha) async {
    List<String> horas = await Consultas().obtenerHorasCreacion(_fecha);
    setState(() {
      _horasList = horas;
    });
  }

  Future<void> _crearCita() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate != null &&
          _selectedDate!.weekday != DateTime.saturday &&
          _selectedDate!.weekday != DateTime.sunday) {
        if (_fecha.isEmpty) {
          Mensajes().showErrorDialog(context, 'Debes de seleccionar una fecha');
          return;
        }
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
            _selectedDate = null; // Restablece la selección de fecha
          });

          Mensajes().showSuccessDialog(context, 'Cita creada con éxito');
        } else {
          Mensajes().showErrorDialog(context, 'Error al crear la cita');
        }
      } else {
        Mensajes().showErrorDialog(context, 'Debes de seleccionar una fecha');
      }
    } else {
      Mensajes().showErrorDialog(context, 'Debes de llenar todos los campos');
    }
  }

  Future<void> _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (selectedDay.weekday != DateTime.saturday &&
        selectedDay.weekday != DateTime.sunday) {
      String fechaSeleccionada =
          '${selectedDay.day}/${selectedDay.month}/${selectedDay.year}';

      setState(() {
        _fecha = fechaSeleccionada;
        _selectedDate = selectedDay;

        // Obtener las horas disponibles para la fecha seleccionada
        Consultas().obtenerHorasCreacion(_fecha).then((horasDisponibles) {
          Set<String> horasUnicas = Set.from(horasDisponibles);

          setState(() {
            _horasList = horasUnicas.toList();
          });
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Los fines de semana no están disponibles.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ingresa Motivo:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: 8),
              _motivosList.isEmpty
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      hint: Text(
                        'Selecciona el motivo de tu cita',
                        style: TextStyle(fontSize: screenWidth * 0.035),
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
                              style: TextStyle(fontSize: screenWidth * 0.035),
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
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: 8),
              TableCalendar(
                focusedDay: _selectedDate ??
                    DateTime.now(), // Si no hay selección, usa la fecha actual
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
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: 8),
              _horasList.isEmpty
                  ? CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      hint: Text(
                        'Selecciona una hora',
                        style: TextStyle(fontSize: screenWidth * 0.035),
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
                              style: TextStyle(fontSize: screenWidth * 0.035),
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
                      EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.1, vertical: 12),
                    ),
                  ),
                  onPressed: _crearCita,
                  child: Text(
                    'Generar Cita',
                    style: TextStyle(
                        color: Colors.black, fontSize: screenWidth * 0.04),
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
