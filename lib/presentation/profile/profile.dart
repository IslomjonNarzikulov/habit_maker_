import 'package:flutter/material.dart';
import 'package:habit_maker/presentation/profile/profile_provider.dart';
import 'package:habit_maker/presentation/profile/widgets_profile/widget.content.dart';
import 'package:habit_maker/presentation/profile/widgets_profile/widget_avatar.dart';
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Positioned(
                top: 33,
                child: userAvatar()),
          ),
          buildContent(),
        ],
      )
    );
  }
}
