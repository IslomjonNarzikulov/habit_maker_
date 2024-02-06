import 'package:flutter/material.dart';

Widget textFieldItem(
  double w,
  TextEditingController emailController,
  TextEditingController passwordController,
) {
  return Container(
    width: w,
    margin: const EdgeInsets.only(left: 20, right: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 80,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 7,
                color: Colors.grey.withOpacity(0.2),
              ),
            ],
          ),
          child: TextField(
            style: const TextStyle(color: Colors.black),
            controller: emailController,
            decoration: InputDecoration(
              hintText: "Email",
              hintStyle: const TextStyle(color: Colors.black),
              prefixIcon: const Icon(
                Icons.mail,
                color: Colors.deepOrange,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 7,
                    color: Colors.grey.withOpacity(0.2))
              ]),
          child: TextField(
            style: const TextStyle(color: Colors.black),
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle: const TextStyle(color: Colors.black),
              prefixIcon: const Icon(
                Icons.lock_clock_outlined,
                color: Colors.deepOrange,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    ),
  );
}
