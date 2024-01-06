import 'package:flutter/material.dart';
import 'package:habit_maker/login/signIn.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:provider/provider.dart';
import '../analytics/analytics.dart';
import '../daily_page/daily_page.dart';
import '../profile/profile.dart';
import '../settings/settings.dart';
import '../weekly/weekly.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HabitProvider provider;
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    DailyPage(),
    Weekly(),
    AnalyticsPage(),
  ];

  @override
  void initState() {
    provider =  Provider.of<HabitProvider>(context,listen: false);
    super.initState();

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
              iconColor: Colors.blue,
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              iconColor: Colors.blue,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.approval_sharp),
              title: const Text('More Apps'),
              onTap: () {},
              iconColor: Colors.blue,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.line_weight_sharp), label: 'Daily'),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_week_outlined), label: 'Weekly'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Analytics'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
      ),
    );
  }
}

