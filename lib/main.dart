import 'package:flutter/material.dart';
import '/src/features/authentication/screen/LoginPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WanderLog',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const LoginPage(
        imageUrl: 'https://source.unsplash.com/featured/?travel,nature',
      ),

      debugShowCheckedModeBanner: false,
    );
  }
}
