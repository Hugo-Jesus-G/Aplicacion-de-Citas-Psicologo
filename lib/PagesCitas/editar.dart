import 'package:flutter/material.dart';
import 'package:proyecto/Mensajes/mensajes.dart';
import 'package:proyecto/firebase/consultas.dart';
import 'package:table_calendar/table_calendar.dart';

class EditarCitaPage extends StatefulWidget {
  final String citaId;
  final String motivo;
  final String fecha;
  final String hora;

  EditarCitaPage({
    required this.citaId,
    required this.motivo,
    required this.fecha,
    required this.hora,
  });

  @override
  _EditarCitaPageState createState() => _EditarCitaPageState();
}

class _EditarCitaPageState extends State<EditarCitaPage> {
  final _formKey = GlobalKey<FormState>();
  late String _nuevoMotivo;
  late String _nuevaFecha;
  late String _nuevaHora;
  late String _fecha;
  DateTime? _selectedDate;
  List<String> _motivosList = [];
  List<String> _horasList = [];

  Future<void> _obtenerMotivos() async {
    List<String> motivos = await Consultas().obtenerMotivos();
    setState(() {
      _motivosList = motivos;
    });
  }

  Future<void> _obtenerHoras() async {
    List<String> horas = await Consultas().obtenerHorasEdit();
    setState(() {
      // Eliminar duplicados de la lista de horas
      _horasList = horas.toSet().toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _nuevoMotivo = widget.motivo;
    _nuevaFecha = widget.fecha;
    _nuevaHora = widget.hora;
    _obtenerMotivos();
    _obtenerHoras();
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      bool citaExistente =
          await Consultas().verificarCitaExistente(_nuevaFecha, _nuevaHora);

      if (citaExistente) {
        Mensajes().showErrorDialog(context,
            'Error ya existe una cita programada para esa fecha y hora.');
        return;
      }

      await Consultas()
          .editarCita(widget.citaId, _nuevoMotivo, _nuevaFecha, _nuevaHora);

      Navigator.pop(context);
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (selectedDay.weekday != DateTime.saturday &&
        selectedDay.weekday != DateTime.sunday) {
      setState(() {
        _selectedDate = selectedDay;
        _nuevaFecha =
            '${selectedDay.day}/${selectedDay.month}/${selectedDay.year}';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Los fines de semana no están disponibles.')),
      );
    }
  }

  String _convertirFecha(String fecha) {
    // Divide la fecha usando '/' como separador
    List<String> partesFecha = fecha.split('/');

    // Convierte las partes a enteros (día, mes, año)
    int dia = int.parse(partesFecha[0]);
    int mes = int.parse(partesFecha[1]);
    int ano = int.parse(partesFecha[2]);

    // Devuelve la fecha en formato 'yyyy-MM-dd'
    return '$ano-${mes.toString().padLeft(2, '0')}-${dia.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text('Editar Cita'),
        backgroundColor: Color.fromARGB(
            255, 255, 255, 255), // Color verde para la barra de navegación
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editar detalles de la cita',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                _motivosList.isEmpty
                    ? CircularProgressIndicator()
                    : DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                        ),
                        hint: Text(
                          'Selecciona el motivo de tu cita',
                          style: TextStyle(
                              fontSize: screenWidth *
                                  0.035), // Tamaño de letra más pequeño
                        ),
                        value: _nuevoMotivo.isNotEmpty ? _nuevoMotivo : null,
                        onChanged: (String? valor) {
                          setState(() {
                            _nuevoMotivo = valor ?? '';
                          });
                        },
                        items: _motivosList
                            .map<DropdownMenuItem<String>>((String motivo) {
                          return DropdownMenuItem<String>(
                            value: motivo,
                            child: Center(
                              child: Text(
                                motivo,
                                style: TextStyle(
                                    fontSize: screenWidth *
                                        0.035), // Tamaño de letra más pequeño
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
                SizedBox(height: 16),
                SizedBox(height: 8),
                TableCalendar(
                  focusedDay: DateTime.parse(_convertirFecha(_nuevaFecha)),
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
                SizedBox(height: 8),
                _horasList.isEmpty
                    ? CircularProgressIndicator()
                    : DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                        ),
                        hint: Text(
                          'Selecciona una hora',
                          style: TextStyle(
                              fontSize: screenWidth *
                                  0.035), // Tamaño de letra más pequeño
                        ),
                        value: _nuevaHora.isNotEmpty ? _nuevaHora : null,
                        onChanged: (String? valor) {
                          setState(() {
                            _nuevaHora = valor ?? '';
                          });
                        },
                        items: _horasList
                            .map<DropdownMenuItem<String>>((String hora) {
                          return DropdownMenuItem<String>(
                            value: hora,
                            child: Center(
                              child: Text(
                                hora,
                                style: TextStyle(
                                    fontSize: screenWidth *
                                        0.035), // Tamaño de letra más pequeño
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
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color(0xFFC5E0F8)), // Color verde
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ))),
                  onPressed: _guardarCambios,
                  child: Text(
                    'Guardar Cambios',
                    style: TextStyle(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
