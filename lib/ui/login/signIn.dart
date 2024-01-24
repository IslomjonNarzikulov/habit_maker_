import 'package:flutter/material.dart';
import 'package:habit_maker/ui/login/sign_in_provider.dart';
import 'package:provider/provider.dart';

import '../../UI/home/home.dart';
import '../signup/signUp.dart';

class SignInPage extends StatefulWidget {
  SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late SignInProvider signInProvider;

  @override
  void initState() {
    super.initState();
    signInProvider = Provider.of<SignInProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: w,
              height: h * 0.3,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/lottie/hey.jpg'),
                    fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  SizedBox(height: h * 0.16),
                ],
              ),
            ),
            Container(
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
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 1.0),
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
            ),
            ElevatedButton(
              onPressed: () {
                var username = emailController.text;
                var password = passwordController.text;
                signInProvider.signIn(username, password, () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }, () {});
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 60,
                child: const Center(
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 24, color: Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SignUp(),
                  ),
                );
              },
              child: const Text(
                'Register now',
                style: TextStyle(color: Colors.blueAccent, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
