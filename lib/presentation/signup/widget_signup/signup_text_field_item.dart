import 'package:flutter/material.dart';
import 'package:habit_maker/common/my_textfield.dart';

Widget texItem(double w,
    double h,
    TextEditingController usernameController,
    TextEditingController passwordController
    ) {
  return Column(
    children: [
      Container(
        width: w,
        height: h * 0.3,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/lottie/hey.jpg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SizedBox(height: h * 0.16),
          ],
        ),
      ),
      const SizedBox(height: 50),
      const Text(
        "Let's register now",
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      const SizedBox(
        height: 25,
      ),
      MyTextField(
          controller: usernameController,
          hintText: 'Enter your email',
          obscureText: false),
      const SizedBox(height: 25),
      MyTextField(
        controller: passwordController,
        hintText: 'Password',
        obscureText: true,
      ),
    ],
  );


}