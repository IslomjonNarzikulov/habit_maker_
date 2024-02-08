import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/presentation/analytics_screen/analytics.dart';
import 'package:habit_maker/presentation/create_screen/create_habit.dart';
import 'package:habit_maker/presentation/home/provider/logout_provider.dart';
import 'package:habit_maker/presentation/profile/profile.dart';
import 'package:habit_maker/presentation/settings/settings.dart';
import 'package:provider/provider.dart';

import '../daily_screen/daily_screen.dart';
import '../weekly/weekly.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  static final List<Widget> _widgetOptions = <Widget>[
    DailyScreen(),
    Weekly(),
    AnalyticsPage(),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LogoutProvider provider;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    provider = Provider.of<LogoutProvider>(context, listen: false);
    provider.isLogged();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
             context.push('/home/create');
            },
            icon: const Icon(Icons.add),
          ),
        ],
        title: const Text('Habit Tracker'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
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
            provider.loggedState== true
                ? ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Log out'),
                    onTap: () {
                      provider.isLogout();
                      Navigator.pop(context);
                    },
                  )
                : ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Log in'),
                    onTap: () {
                      context.replace('/login');
                    })
          ],
        ),
      ),
      body: Center(child: HomeScreen._widgetOptions.elementAt(_selectedIndex)),
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
