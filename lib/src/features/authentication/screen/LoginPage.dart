import 'package:flutter/material.dart';
import 'dart:math';

class LoginPage extends StatefulWidget {
  final String? imageUrl;
  const LoginPage({Key? key, this.imageUrl}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late String _backgroundImage;

  // List of local asset images
  final List<String> _imageAssets = [
    'lib/assets/images/background1.jpg',
    'lib/assets/images/background2.jpg',
    'lib/assets/images/background3.jpg',
    'lib/assets/images/background4.jpg',
    'lib/assets/images/background5.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _refreshBackgroundImage();
  }

  void _refreshBackgroundImage() {
    // Select a random image from the list
    final random = Random();
    setState(() {
      _backgroundImage = _imageAssets[random.nextInt(_imageAssets.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              _backgroundImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print("Image error: $error");
                return Container(
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Text(
                      "Failed to load image",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),


          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          // Foreground form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              labelText: "Email",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null || !value.contains('@')
                                ? "Enter a valid email"
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              labelText: "Password",
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (value) => value == null || value.length < 6
                                ? "Password must be at least 6 characters"
                                : null,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // TODO: Login action
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Login", style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}