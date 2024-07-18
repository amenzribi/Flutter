import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sqlite_auth_app/models/entete.dart';
import 'package:flutter_sqlite_auth_app/SQLite/database_helper.dart';
import 'add_stock_page.dart';

class EnteteListPage extends StatefulWidget {
  const EnteteListPage({Key? key}) : super(key: key);

  @override
  _EnteteListPageState createState() => _EnteteListPageState();
}

class _EnteteListPageState extends State<EnteteListPage> {
  final DatabaseHelper _databaseService = DatabaseHelper.instance;
  List<Entete> _entetes = [];

  @override
  void initState() {
    super.initState();
    _fetchEntetes();
  }

  Future<void> _fetchEntetes() async {
    final entetes = await _databaseService.getEntetes();
    setState(() {
      _entetes = entetes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Entêtes'),
      ),
      body: _entetes.isEmpty
          ? Center(
              child: Text('Aucune entête trouvée'),
            )
          : ListView.builder(
              itemCount: _entetes.length,
              itemBuilder: (context, index) {
                final entete = _entetes[index];
                final formattedDate =
                    DateFormat('yyyy-MM-dd').format(entete.dateEntete);
                return ListTile(
                  title: Text(entete.description),
                  subtitle: Text('Date: $formattedDate'),
                  onTap: () {
                    if (entete.id != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddStockPage(enteteId: entete.id),
                        ),
                      );
                    } else {
                      // Gérer le cas où entete.id est null
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Erreur: ID de l\'entête est null')),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
