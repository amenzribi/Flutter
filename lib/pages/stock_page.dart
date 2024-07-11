import 'package:flutter/material.dart';
import 'package:flutter_sqlite_auth_app/models/article.dart';
import 'package:flutter_sqlite_auth_app/models/stock.dart';
import 'package:intl/intl.dart'; // Importez intl pour la gestion de la date

import 'package:flutter_sqlite_auth_app/SQLite/database_helper.dart';

class StockPage extends StatefulWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final DatabaseHelper _databaseService = DatabaseHelper.instance;

  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _articleController =
      TextEditingController(); // Vous n'en aurez pas besoin
  final _quantiteController = TextEditingController();

  List<Article> _articles = [];
  List<DropdownMenuItem<Article>> _articleDropdownItems = [];
  Article? _selectedArticle;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _articleController.dispose(); // Disposez le controller
    _quantiteController.dispose();
    super.dispose();
  }

  Future<void> _loadArticles() async {
    _articles = await _databaseService.getArticles();
    _articleDropdownItems = _articles.map((article) {
      return DropdownMenuItem<Article>(
        value: article,
        child: Text(article.designationArticle),
      );
    }).toList();
    setState(() {});
  }

  Future<void> _addStock() async {
    if (_formKey.currentState!.validate()) {
      final newStock = Stock(
        id: 0, // L'ID sera automatiquement généré
        dateStock: DateTime.parse(_dateController.text),
        article: _selectedArticle!,
        quantite: int.parse(_quantiteController.text),
      );
      await _databaseService.insertStock(newStock);
      // ... (Vous pouvez ajouter du code pour afficher un message de succès ou recharger la liste)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock'),
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
                    return 'Veuillez saisir une date de stock';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Date Stock',
                ),
              ),
              DropdownButtonFormField<Article>(
                value: _selectedArticle,
                decoration: const InputDecoration(
                  labelText: 'Article',
                ),
                items: _articleDropdownItems,
                onChanged: (value) {
                  setState(() {
                    _selectedArticle = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez choisir un article';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantiteController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une quantité';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Quantité',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addStock,
                child: const Text('Ajouter Stock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
