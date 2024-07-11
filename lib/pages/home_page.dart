import 'package:flutter/material.dart';
import 'package:flutter_sqlite_auth_app/models/article.dart';
import 'package:flutter_sqlite_auth_app/pages/stock_page.dart';

import 'package:flutter_sqlite_auth_app/SQLite/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _databaseService = DatabaseHelper.instance;

  final _formKey = GlobalKey<FormState>();
  final _refArticleController = TextEditingController();
  final _designationArticleController = TextEditingController();

  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  @override
  void dispose() {
    _refArticleController.dispose();
    _designationArticleController.dispose();
    super.dispose();
  }

  Future<void> _loadArticles() async {
    _articles = await _databaseService.getArticles();
    setState(() {});
  }

  Future<void> _addArticle() async {
    if (_formKey.currentState!.validate()) {
      final newArticle = Article(
        id: 0,
        refArticle: _refArticleController.text,
        designationArticle: _designationArticleController.text,
      );
      await _databaseService.insertArticle(newArticle);
      _loadArticles();
      _refArticleController.clear();
      _designationArticleController.clear();
    }
  }

  Future<void> _updateArticle(Article article) async {
    _refArticleController.text = article.refArticle;
    _designationArticleController.text = article.designationArticle;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier Article'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _refArticleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une référence d\'article';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Référence Article',
                ),
              ),
              TextFormField(
                controller: _designationArticleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir une désignation d\'article';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Désignation Article',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final updatedArticle = Article(
                  id: article.id,
                  refArticle: _refArticleController.text,
                  designationArticle: _designationArticleController.text,
                );
                await _databaseService.updateArticle(updatedArticle);
                _loadArticles();
                Navigator.pop(context);
                _refArticleController.clear();
                _designationArticleController.clear();
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteArticle(int id) async {
    await _databaseService.deleteArticle(id);
    _loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Articles'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return ListTile(
                  title: Text(article.designationArticle),
                  subtitle: Text(article.refArticle),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _updateArticle(article),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () => _deleteArticle(article.id),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _refArticleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir une référence d\'article';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Référence Article',
                    ),
                  ),
                  TextFormField(
                    controller: _designationArticleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir une désignation d\'article';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Désignation Article',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _addArticle,
                    child: const Text('Ajouter Article'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StockPage()),
          );
        },
        child: const Icon(Icons.inventory), // Utilisez un icone Inventaire
      ),
    );
  }
}
