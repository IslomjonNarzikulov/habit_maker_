import 'package:flutter/material.dart';

Widget listItem( IconData icon,String text, VoidCallback onPressed){
  return ListTile(
    leading: Icon(icon),
    title: Text(text),
    onTap: onPressed,
  );
}