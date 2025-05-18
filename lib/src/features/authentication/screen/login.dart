import 'package:flutter/material.dart';

class login extends StatelessWidget{
  const login{Key? key} : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SingleChildScrollView(
    child: Container(
padding: const EdgeInsets.all(),
child: Column(
children: [
  Image(image: const AssetImage("assets/image/landmarks.png")),
Text()
],
),
    ),
),
    );
  }
}
