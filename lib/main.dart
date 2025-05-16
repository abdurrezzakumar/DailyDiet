import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/diet_plan_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(DAILYDIETApp());
}

class DAILYDIETApp extends StatefulWidget {
  @override
  _DAILYDIETAppState createState() => _DAILYDIETAppState();
}

class _DAILYDIETAppState extends State<DAILYDIETApp> {
  int _selectedIndex = 0; // Varsayılan olarak Ana Sayfa seçili

  final List<Widget> _screens = [
    HomeScreen(),
    DietPlanScreen(),
    ChatbotScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DAILYDIET',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
              BottomNavigationBarItem(icon: Icon(Icons.food_bank), label: 'Diyet'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            onTap: (index) => setState(() => _selectedIndex = index),
          ),
        ),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}