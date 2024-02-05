import 'package:flutter/material.dart';
import 'package:habit_maker/presentation/home/home.dart';
import 'package:habit_maker/presentation/login/loginScreen.dart';
import 'package:habit_maker/presentation/main_provider.dart';
import 'package:habit_maker/presentation/settings/settings.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainProvider provider = Provider.of<MainProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.approval_sharp),
            title: const Text('More Apps'),
            onTap: () {},
          ),
          Consumer<MainProvider>(
            builder: (context, value, child) {
              if (!provider.isLoggedState) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Login'),
                  onTap: () {
                    provider.isLogged();
                    print('logged in');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogInScreen(),
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          Consumer<MainProvider>(
            builder: (context, value, child) {
              if (provider.isLoggedState) {
                return ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log out'),
                  onTap: () {
                    provider.isLoggedOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
