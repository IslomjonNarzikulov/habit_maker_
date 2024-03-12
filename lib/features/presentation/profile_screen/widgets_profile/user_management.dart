import 'package:flutter/material.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: '');
    emailController = TextEditingController(text: '');
    phoneController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CircleAvatar(
              radius: 100.0,
              backgroundImage: AssetImage('assets/lottie/blank.png'),
            ),
            SizedBox(height: 20.0),
            // User Details
            UserInfoFormField(label: 'Name', controller: nameController),
            UserInfoFormField(label: 'Email', controller: emailController),
            UserInfoFormField(label: 'Phone', controller: phoneController),
            SizedBox(height: 20.0),
            // Save Button
            ElevatedButton(
              onPressed: () {

              },
              child: Text('Save',style: TextStyle(color: Colors.blue),),
            ),

          ],
        ),
      ),
    );
  }
}

class UserInfoFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  UserInfoFormField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.0),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}

