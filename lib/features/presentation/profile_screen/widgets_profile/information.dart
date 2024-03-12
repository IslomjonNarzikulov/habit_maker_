import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information about developer'),
      ),
      body:
         const Text(
          'App developed by Senior and junior developers.',
          style: TextStyle(fontSize: 24, color: Colors.blue),
        ),
    );
  }
}
