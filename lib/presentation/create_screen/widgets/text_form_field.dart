import 'package:flutter/material.dart';

Widget textForm(TextEditingController titleController){
  return Container(
    height: 85,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    child: TextFormField(
      controller: titleController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.green),
        ),
        filled: true,
        hintText: 'Enter title',
      ),
      validator: (value) {
        if (titleController.text.trim().isEmpty) {
          return 'Invalid input';
        }
        return null;
      },
    ),
  );
}