import 'package:flutter/material.dart';
import 'package:habit_maker/common/my_textfield.dart';
import 'package:habit_maker/ui/signup/restore_provider.dart';
import 'package:provider/provider.dart';

class RestorePassword extends StatefulWidget {
  RestorePassword({super.key});

  @override
  State<RestorePassword> createState() => _RestorePasswordState();
}

class _RestorePasswordState extends State<RestorePassword> {
  late RestoreProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<RestoreProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
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
