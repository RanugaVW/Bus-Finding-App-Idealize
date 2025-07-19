import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Login screen
import 'home_screen.dart'; // Home screen
import 'registration_screen.dart'; // Registration screen
import 'profile_screen.dart'; // Profile screen
import 'routes_screen.dart'; // Routes screen
import 'update_location_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Finding App',
      initialRoute: '/login', // Starting with login screen
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/register': (context) => RegistrationScreen(),
        '/profile': (context) => ProfileScreen(),
        '/routes': (context) => RoutesScreen(),
        '/update_location': (context) => UpdateLocationScreen(),
      },
    );
  }
}
