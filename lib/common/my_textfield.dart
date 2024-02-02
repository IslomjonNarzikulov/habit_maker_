import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: controller,
        obscureText: obscureText,
        decoration:  InputDecoration(
            border: OutlineInputBorder(borderRadius:
            BorderRadius.circular(18)),
            hintText: hintText,
            focusedBorder:const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black))),
      ),
    );
  }
}
