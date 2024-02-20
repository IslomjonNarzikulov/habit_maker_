import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/features/presentation/otp_screen/widget_otp_screen/widget_input_box.dart';
import 'package:habit_maker/features/presentation/sign_up_screen/signup_provider.dart';
import 'package:provider/provider.dart';
import '../home/home.dart';

class OtpPage extends StatelessWidget {
  OtpPage({super.key});

  TextEditingController txt1 = TextEditingController();
  TextEditingController txt2 = TextEditingController();
  TextEditingController txt3 = TextEditingController();
  TextEditingController txt4 = TextEditingController();
  TextEditingController txt5 = TextEditingController();
  TextEditingController txt6 = TextEditingController();

  late SignUpProvider signUpController;

  @override
  Widget build(BuildContext context) {
    signUpController = Provider.of<SignUpProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Verification'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
           context.pop();// Navigate back when the back button is pressed
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Verification code',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Enter the code you received",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myInputBox(context, txt1),
                  myInputBox(context, txt2),
                  myInputBox(context, txt3),
                  myInputBox(context, txt4),
                  myInputBox(context, txt5),
                  myInputBox(context, txt6),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: () {
                  var otp = txt1.text +
                      txt2.text +
                      txt3.text +
                      txt4.text +
                      txt5.text +
                      txt6.text;
                  signUpController.verify(otp, () {
                    if (otp.isNotEmpty) {
                     context.push('/home');
                    }
                  }, () {});
                },
                child: Container(
                  width: 90,
                  child: const Text(
                    'Verify',
                    style: TextStyle(fontSize: 24, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "Didn't get the code yet?",
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}

