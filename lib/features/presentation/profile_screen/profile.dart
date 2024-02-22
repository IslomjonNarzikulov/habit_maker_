import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/features/presentation/profile_screen/profile_provider.dart';
import 'package:habit_maker/features/presentation/profile_screen/widgets_profile/tprofile_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ProfileProvider>(context, listen: false);
    provider.isLogged();
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    print('profile:${provider.loggedState.toString()}');

    return Consumer<ProfileProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(LineAwesomeIcons.angle_left)),
          title: Text('Profile', style: Theme.of(context).textTheme.headline4),
          actions: [
            IconButton(
                onPressed: () {},
                icon:
                    Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
          ],
        ),
        body: Center(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: provider.loggedState == true
                  ? Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return GridView.count(
                                    crossAxisCount: 3,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          provider.selectAvatar('assets/lottie/avatar.jpg');
                                          Navigator.pop(context);
                                        },
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/lottie/avatar.jpg'),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context,
                                              'assets/lottie/blank.png');
                                        },
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/lottie/blank.png'),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Handle selecting this image as avatar
                                          Navigator.pop(context,
                                              'assets/lottie/blank.png');
                                        },
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/lottie/blank.png'),
                                        ),
                                      ),
                                      // Add more GestureDetector widgets for additional images
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Image(
                              image: AssetImage('assets/lottie/blank.png'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${provider.userFirstName} ${provider.userLastName}',
                          style: const TextStyle(fontSize: 24),
                        ),
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
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return GridView.count(
                                        crossAxisCount: 3,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              provider.selectAvatar('assets/lottie/avatar.jpg');
                                            },
                                            child: const Image(
                                              image: AssetImage(
                                                  'assets/lottie/avatar.jpg'),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                            },
                                            child: const Image(
                                              image: AssetImage(
                                                  'assets/lottie/blank.png'),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context,
                                                  'assets/lottie/blank.png');
                                            },
                                            child: const Image(
                                              image: AssetImage(
                                                  'assets/lottie/blank.png'),
                                            ),
                                          ),
                                          // Add more GestureDetector widgets for additional images
                                        ],
                                      );
                                    },
                                  );
                                },
                                child:  Image(
                                  image: AssetImage(provider.selectedImagePath),
                                ),
                              ),
                            ),
                          ),
                          const Gap(15),
                          const Text('Jack sparrow',
                              style: TextStyle(color: Colors.black)),
                          Text('Pirate',
                              style: Theme.of(context).textTheme.bodyText2),
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
