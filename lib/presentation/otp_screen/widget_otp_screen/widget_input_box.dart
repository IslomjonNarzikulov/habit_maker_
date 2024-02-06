
import 'package:flutter/material.dart';

Widget myInputBox(BuildContext context, TextEditingController controller) {
  return Container(
    height: 70,
    width: 50,
    decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        )),
    child: TextField(
      controller: controller,
      maxLength: 1,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 42),
      decoration: const InputDecoration(counterText: ''),
      onChanged: (value) {
        if (value.length == 1) {
          FocusScope.of(context).nextFocus();
        }
      },
    ),
  );
}


