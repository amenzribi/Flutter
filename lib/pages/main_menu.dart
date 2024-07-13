import 'package:flutter/material.dart';
import 'package:flutter_sqlite_auth_app/models/article.dart';
import 'package:flutter_sqlite_auth_app/pages/stock_page.dart';

import 'package:flutter_sqlite_auth_app/pages/home_page.dart';
import 'package:flutter_sqlite_auth_app/Views/profile.dart'; // Import Profile

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Principal'),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/auth');
          },
          icon: const Icon(Icons.logout),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/article');
              },
              child: const Text('Article'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/stock');
              },
              child: const Text('Mouvement Sortie'),
            ),
          ],
        ),
      ),
    );
  }
}
