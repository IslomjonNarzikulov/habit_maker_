import 'package:flutter/material.dart';
import 'package:habit_maker/ui/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileProvider provider;

  @override
  void initState() {
    provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
