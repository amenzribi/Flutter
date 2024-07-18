import 'package:flutter/material.dart';
import 'package:flutter_sqlite_auth_app/models/entete.dart';
import 'package:flutter_sqlite_auth_app/SQLite/database_helper.dart';
import 'package:intl/intl.dart';

class EnteteFormPage extends StatefulWidget {
  const EnteteFormPage({Key? key}) : super(key: key);

  @override
  State<EnteteFormPage> createState() => _EnteteFormPageState();
}

class _EnteteFormPageState extends State<EnteteFormPage> {
  final DatabaseHelper _databaseService = DatabaseHelper.instance;
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addEntete() async {
    if (_formKey.currentState!.validate()) {
      try {
        final newEntete = Entete(
          dateEntete: DateTime.parse(_dateController.text),
          description: _descriptionController.text,
        );
        await _databaseService.insertEntete(newEntete);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erreur lors de la conversion de la date : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter Entete'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une date';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Date Entete',
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une description';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addEntete,
                child: const Text('Ajouter Entete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
