import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sqlite_auth_app/JSON/users.dart';
import 'package:flutter_sqlite_auth_app/Views/auth.dart';
import 'package:flutter_sqlite_auth_app/Views/profile.dart';
import 'package:flutter_sqlite_auth_app/models/article.dart';
import 'package:flutter_sqlite_auth_app/pages/home_page.dart';
import 'package:flutter_sqlite_auth_app/pages/main_menu.dart';
import 'package:flutter_sqlite_auth_app/pages/stock_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit(); // Initialize sqflite_ffi
  databaseFactory = databaseFactoryFfi; // Assign the database factory

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthScreen(),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/main_menu': (context) => const MainMenu(),
        '/profile': (context) => Profile(
            profile: ModalRoute.of(context)!.settings.arguments
                as Users?), // Pass the user details
        '/article': (context) => const HomePage(), // Route for ArticlePage
        '/stock': (context) => const StockPage(), // Route for StockPage
      },
      // routes: {
      //    '/auth': (context) => const AuthScreen(),
      //  },
    );
  }
}
