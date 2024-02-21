import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/features/presentation/sign_up_screen/widget_signup/signup_text_field_item.dart';
import 'package:provider/provider.dart';

import 'signup_provider.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late SignUpProvider signUpProvider;

  @override
  Widget build(BuildContext context) {
    signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              texItem(w, h, usernameController, passwordController),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: () {
                  var username = usernameController.text;
                  var password = passwordController.text;
                  signUpProvider.signUp(username, password, () {
                   context.go('/login/verify');
                  }, () {});
                },
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 60,
                    child: const Center(
                        child: Text(
                      'Register',
                      style: TextStyle(fontSize: 20),
                    ))),
              ),
              const SizedBox(
                height: 18,
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                     context.push('/login/restore');
                    },
                    child: const Text('Forget password?',style: TextStyle(color: Colors.blue,fontSize: 16),)),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: () {
                 context.push('/login');
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 40,
                    child: const Center(
                        child: Text(
                      'Login',
                      style: TextStyle(fontSize: 20),
                    ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
