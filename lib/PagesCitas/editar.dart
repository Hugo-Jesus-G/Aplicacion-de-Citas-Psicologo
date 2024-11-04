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
      Navigator.pop(context); // Regresar a la pantalla anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _nuevoMotivo,
                decoration: InputDecoration(labelText: 'Motivo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un motivo';
                  }
                  return null;
                },
                onChanged: (value) => _nuevoMotivo = value,
              ),
              TextFormField(
                initialValue: _nuevaFecha,
                decoration: InputDecoration(labelText: 'Fecha (dd/MM/yyyy)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una fecha';
                  }
                  return null;
                },
                onChanged: (value) => _nuevaFecha = value,
              ),
              TextFormField(
                initialValue: _nuevaHora,
                decoration: InputDecoration(labelText: 'Hora (HH:mm)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una hora';
                  }
                  return null;
                },
                onChanged: (value) => _nuevaHora = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarCambios,
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
