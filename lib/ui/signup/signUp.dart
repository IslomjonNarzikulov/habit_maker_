import 'package:flutter/material.dart';
import 'package:habit_maker/common/my_textfield.dart';
import 'package:habit_maker/login/signIn.dart';
import 'package:habit_maker/ui/signup/signup_provider.dart';
import 'package:provider/provider.dart';

import '../otp_page/otp_page.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late SignUpProvider signUpProvider;

  @override
  void initState() {
    super.initState();
    signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
  }

  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Incorrect input. '),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.black,
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
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  onPressed: () {
                    var username = usernameController.text;
                    var password = passwordController.text;
                    signUpProvider.signUp(username, password, () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OtpPage()));
                    }, () {});
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 60,
                      child: const Center(
                          child: Text(
                        'Register',
                        style: TextStyle(fontSize: 20),
                      ))),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Or continue with'),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
             ElevatedButton(onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
             },
                 child:  Container(
                     width: MediaQuery.of(context).size.width * 0.5,
                     height: 40,
                     child: const Center(
                         child: Text(
                           'Login',
                           style: TextStyle(fontSize: 20),
                         ))),
             )],
            ),
          ),
        ),
      ),
    );
  }
}
