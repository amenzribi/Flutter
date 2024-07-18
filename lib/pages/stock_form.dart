import 'package:flutter/material.dart';
import 'package:flutter_sqlite_auth_app/models/article.dart';
import 'package:flutter_sqlite_auth_app/models/stock.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sqlite_auth_app/SQLite/database_helper.dart';

class StockForm extends StatefulWidget {
  final int enteteId; // Make enteteId required

  const StockForm({Key? key, required this.enteteId}) : super(key: key);

  @override
  State<StockForm> createState() => _StockFormState();
}

class _StockFormState extends State<StockForm> {
  final DatabaseHelper _databaseService = DatabaseHelper.instance;

  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _articleController = TextEditingController();
  final _quantiteController = TextEditingController();

  List<Article> _articles = [];
  List<DropdownMenuItem<Article>> _articleDropdownItems = [];
  Article? _selectedArticle;

  // Store enteteId from arguments in a non-final variable
  int _receivedEnteteId = 0; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    _loadArticles();
    // Access enteteId from the arguments
    //  final enteteId = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //_receivedEnteteId = enteteId['enteteId']; // Store in non-final variable
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;

    // Check if arguments are not null and are of the correct type
    if (arguments is Map<String, dynamic> &&
        arguments.containsKey('enteteId')) {
      _receivedEnteteId = arguments['enteteId'];
    } else {
      // Handle the case where arguments are not valid
      print('Error: Invalid arguments or missing enteteId');
      // You can display an error message to the user here, e.g., using a SnackBar
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _articleController.dispose();
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
        id: 0,
        dateStock: DateTime.parse(_dateController.text),
        articleId: _selectedArticle!.id,
        enteteId: _receivedEnteteId, // Use the received enteteId
        quantite: int.parse(_quantiteController.text),
      );
      await _databaseService.insertStock(newStock);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter Stock'),
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
