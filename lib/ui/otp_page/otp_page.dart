import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/home.dart';
import '../signup/signup_provider.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController txt1 = TextEditingController();
  TextEditingController txt2 = TextEditingController();
  TextEditingController txt3 = TextEditingController();
  TextEditingController txt4 = TextEditingController();
  TextEditingController txt5 = TextEditingController();
  TextEditingController txt6 = TextEditingController();

  late SignUpProvider signUpController;

  @override
  void initState() {
    super.initState();
    signUpController = Provider.of<SignUpProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Verification'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pop(); // Navigate back when the back button is pressed
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
                   if (otp.isNotEmpty){ Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const HomeScreen())); }
                  }, () {});
                },
                child: Container(
                  width: 90,
                  child: const Text(
                    'Verify',
                    style: TextStyle(fontSize: 24),
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

Widget myInputBox(BuildContext context, TextEditingController controller) {
  return Container(
    height: 70,
    width: 50,
    decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        )),
    child: TextField(
      controller: controller,
      maxLength: 1,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontSize: 42),
      decoration: const InputDecoration(counterText: ''),
      onChanged: (value) {
        if (value.length == 1) {
          FocusScope.of(context).nextFocus();
        }
      },
    ),
  );
}
