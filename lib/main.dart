import 'package:flutter/material.dart';
import 'package:muscu/pages/dashboard/main.dart';
import 'package:muscu/models/database_helper.dart';
import 'package:muscu/models/utilisateur/utilisateurs.dart';
import 'package:muscu/models/utilisateur/profils.dart';
import 'package:muscu/models/seance/seance.dart';
import 'package:muscu/pages/testBDD/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper.instance;
  
  // Activer les contraintes de clé étrangère
  final db = await dbHelper.database;
  await db.execute('PRAGMA foreign_keys = ON');
  
  await UserTable.createTable(dbHelper);
  await ProfilTable.createTable(dbHelper);
  await SessionTable.createTable(dbHelper);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GameStore",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF091F44),
        primaryColor: Color(0xFF223B65),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(0xFF223B65, <int, Color>{
            50: Color(0xFFE4E8ED),
            100: Color(0xFFBCC5D3),
            200: Color(0xFF909FB6),
            300: Color(0xFF647998),
            400: Color(0xFF425C82),
            500: Color(0xFF223B65),
            600: Color(0xFF1E355D),
            700: Color(0xFF192D53),
            800: Color(0xFF142649),
            900: Color(0xFF0C1A37),
          }),
          accentColor: Color(0xFFBAF2D8),
        ),
        textTheme: TextTheme(
          displayMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          displayLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          displaySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF223B65),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFBAF2D8),
            foregroundColor: Color(0xFF091F44),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFF091F44),
            foregroundColor: Color(0xFFBAF2D8),
          ),
        ),
      ),
      //home: const DashBoardPage(),
      home: const HomePage(),
    );
  }
}

