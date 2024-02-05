import 'package:flutter/material.dart';
import 'package:habit_maker/presentation/profile/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
   ProfilePage({super.key});

  late ProfileProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Consumer<ProfileProvider>(
          builder:
              (BuildContext context, ProfileProvider value, Widget? child) {
            if (value.name != null && value.surname != null) {
              return Text(
                "${value.name} ${value.surname}",
                style: const TextStyle(fontSize: 36, color: Colors.white),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
