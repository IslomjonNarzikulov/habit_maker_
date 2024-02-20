import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/features/presentation/profile_screen/widgets_profile/tprofile_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

Widget userInfo(BuildContext context, bool loggedState, String userFirstName,
    String userLastName) {
  return loggedState == true
      ? Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: const Image(
                      image: AssetImage('assets/lottie/blank.png'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blue),
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: List.generate(6, (index) {
                        return GestureDetector(
                          onTap: (){},
                          child: const Icon(
                            LineAwesomeIcons.alternate_pencil,
                            color: Colors.black,
                            size: 20,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              '$userFirstName $userLastName',
              style: TextStyle(fontSize: 24),
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
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(
                            image: AssetImage('assets/lottie/blank.png'))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue),
                      child: const Icon(
                        LineAwesomeIcons.alternate_pencil,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(15),
              Text('Jack sparrow',
                  style: Theme.of(context).textTheme.headline4),
              Text('Pirate', style: Theme.of(context).textTheme.bodyText2),
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
        );
}
