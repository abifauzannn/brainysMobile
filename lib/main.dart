import 'package:brainys/screens/authentication/login_page.dart';
import 'package:brainys/screens/authentication/register_page.dart';
import 'package:flutter/material.dart';
import 'package:brainys/screens/authentication/splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(), // Set SplashScreen sebagai halaman default
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}