import 'package:flutter/material.dart';
import 'package:proyecto/firebase/consultas.dart';

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

  @override
  void initState() {
    super.initState();
    _nuevoMotivo = widget.motivo;
    _nuevaFecha = widget.fecha;
    _nuevaHora = widget.hora;
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      await Consultas()
          .editarCita(widget.citaId, _nuevoMotivo, _nuevaFecha, _nuevaHora);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // Permite desplazar el contenido en caso de teclado
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
                TextFormField(
                  initialValue: _nuevoMotivo,
                  decoration: InputDecoration(
                    labelText: 'Motivo',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un motivo';
                    }
                    return null;
                  },
                  onChanged: (value) => _nuevoMotivo = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _nuevaFecha,
                  decoration: InputDecoration(
                    labelText: 'Fecha (dd/MM/yyyy)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una fecha';
                    }
                    return null;
                  },
                  onChanged: (value) => _nuevaFecha = value,
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _nuevaHora,
                  decoration: InputDecoration(
                    labelText: 'Hora (HH:mm)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una hora';
                    }
                    return null;
                  },
                  onChanged: (value) => _nuevaHora = value,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color(0xFFC5E0F8)), // Color verde
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                  ),
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
