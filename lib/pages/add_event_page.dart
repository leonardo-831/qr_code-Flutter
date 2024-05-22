import 'package:flutter/material.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';
import '../database/database_service.dart';
import '../model/event.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String currentTime = DateTime.now().toIso8601String();
      Event newEvent = Event(
        title: _title,
        createdAt: currentTime,
        updatedAt: currentTime,
      );

      await DatabaseService().insertEvent(newEvent);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome do Evento'),
                onSaved: (value) {
                  _title = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o nome do Evento';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEvent,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
