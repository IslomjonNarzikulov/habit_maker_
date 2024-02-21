import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/features/presentation/login_screen/login_provider.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});

  late LogInProvider logInProvider;
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    logInProvider = Provider.of<LogInProvider>(context, listen: false);
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Scaffold(
        body: Stack(children: [
          const Image(
            image: AssetImage('assets/lottie/andrew.jpg'),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.white,
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.5)
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Let's grow with daily habits",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white38,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 220),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: textFieldItem(w, emailController, passwordController),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  onPressed: () {
                    var username = emailController.text;
                    var password = passwordController.text;
                    logInProvider.signIn(username, password, () {
                      context.replace('/home');
                    }, () {});
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 60,
                    child: const Center(
                      child: Text(
                        'Log in',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Divider(thickness: 0.7),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  onPressed: () {
                    context.push('/login/signUp');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: const Center(
                      child: Text(
                        'Register now',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  textFieldItem(
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
              obscureText: !logInProvider.passwordVisible,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: const TextStyle(color: Colors.black),
                prefixIcon: const Icon(
                  Icons.lock_clock_outlined,
                  color: Colors.deepOrange,
                ),
                suffixIcon: IconButton(
                  icon: Icon(logInProvider.passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    logInProvider.passwordVisibility();
                  },
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
            height: 40,
          ),
        ],
      ),
    );
  }
}
