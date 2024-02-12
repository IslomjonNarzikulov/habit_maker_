import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/presentation/login/login_provider.dart';
import 'package:habit_maker/presentation/login/login_widget_item/text_field_item.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});

  late LogInProvider logInProvider;

  @override
  Widget build(BuildContext context) {
    logInProvider = Provider.of<LogInProvider>(context, listen: false);
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
                    image: AssetImage('assets/lottie/hey.jpg'),
                    fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  SizedBox(height: h * 0.16),
                ],
              ),
            ),
            textFieldItem(w, emailController, passwordController),
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
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
