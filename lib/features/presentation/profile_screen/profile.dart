import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/features/presentation/profile_screen/profile_provider.dart';
import 'package:habit_maker/features/presentation/profile_screen/widgets_profile/tprofile_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  late ProfileProvider provider;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, value, child) {
      provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.isLogged();
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(LineAwesomeIcons.angle_left)),
          title: Text('Profile', style: Theme.of(context).textTheme.headline4),
        ),
        body: Center(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: provider.loggedState == true
                  ? Column(
                      children: [
                        SizedBox(
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: const Image(
                              image: AssetImage('assets/lottie/red.jpeg'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'New User ',
                          style: TextStyle(fontSize: 24),
                        ),
                        const Gap(12),
                        Text('${provider.userEmail}'),
                        const Divider(),
                        const SizedBox(height: 10),
                        ProfileMenuWidget(
                            title: "Settings",
                            icon: LineAwesomeIcons.cog,
                            onPress: () {
                              context.push('/home/settings');
                            }),
                        ProfileMenuWidget(
                            title: "Billing Details",
                            icon: LineAwesomeIcons.wallet,
                            onPress: () {}),
                        ProfileMenuWidget(
                            title: "User Management",
                            icon: LineAwesomeIcons.user_check,
                            onPress: () {}),
                        const Divider(),
                        const SizedBox(height: 10),
                        ProfileMenuWidget(
                            title: "Information",
                            icon: LineAwesomeIcons.info,
                            onPress: () {}),
                      ],
                    )
                  : Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 140,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: const Image(
                                image: AssetImage('assets/lottie/blank.png'),
                              ),
                            ),
                          ),
                          const Gap(15),
                          const Text('User',
                              style: TextStyle(fontSize:24,color: Colors.black)),
                          Gap(12),
                          const Divider(),
                          const SizedBox(height: 10),
                          ProfileMenuWidget(
                              title: "Settings",
                              icon: LineAwesomeIcons.cog,
                              onPress: () {
                                context.push('/home/settings');
                              }),
                          ProfileMenuWidget(
                              title: "Billing Details",
                              icon: LineAwesomeIcons.wallet,
                              onPress: () {}),
                          ProfileMenuWidget(
                              title: "User Management",
                              icon: LineAwesomeIcons.user_check,
                              onPress: () {}),
                          const Divider(),
                          const SizedBox(height: 10),
                          ProfileMenuWidget(
                              title: "Information",
                              icon: LineAwesomeIcons.info,
                              onPress: () {}),
                        ],
                      ),
                    )),
        ),
      );
    });
  }
}
