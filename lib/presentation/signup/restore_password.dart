import 'package:flutter/material.dart';
import 'package:habit_maker/common/my_textfield.dart';
import 'package:habit_maker/presentation/signup/restore_provider.dart';
import 'package:provider/provider.dart';

class RestorePassword extends StatelessWidget {
  RestorePassword({super.key});

  late RestoreProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<RestoreProvider>(context, listen: false);

    final emailController = TextEditingController();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
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
            const SizedBox(
              height: 18,
            ),
            MyTextField(
                controller: emailController,
                hintText: 'Enter your email',
                obscureText: false),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 200,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  var restoredPassword = emailController.text;
                  provider.newPassword(restoredPassword, () {}, () {});
                },
                child: const Text('Send the link'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
