import 'package:flutter/material.dart';

Widget userAvatar(){
  return CircleAvatar(
    radius: 77,
    backgroundColor: Colors.grey.shade200,
    backgroundImage: const AssetImage(
      'assets/lottie/blank.png'
    )
  );
}