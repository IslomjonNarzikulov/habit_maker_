import 'package:flutter/material.dart';
import 'package:habit_maker/ui/login/login.dart';
import 'package:habit_maker/ui/main_provider.dart';
import 'package:provider/provider.dart';

import '../../UI/create_habit/create_habit.dart';
import '../analytics/analytics.dart';
import '../daily_page/daily_page.dart';
import '../settings/settings.dart';
import '../weekly/weekly.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MainProvider provider;
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    DailyPage(),
    Weekly(),
    AnalyticsPage(),
  ];

  @override
  void initState() {
    provider = Provider.of<MainProvider>(context, listen: false);
    provider.isLogged();
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
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => CreateHabit(),
                ),
              );
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
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              iconColor: Colors.blue,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  SettingPage(),
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

            Consumer<MainProvider>(
              builder: (context, value, child) {
                if(!provider.isLoggedState){
                  return Visibility(
                    visible: true,
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Login'),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignInPage()));
                      },
                      iconColor: Colors.blue,
                    ),
                  );
                }else{
                  return Container();
                }

              },
            ),
            Consumer<MainProvider>(
              builder: (context, value, child) {
                if(provider.isLoggedState){
                  return Visibility(
                    visible: true,
                    child: ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Log out'),
                      onTap: () {
                        provider.isLoggedOut();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomeScreen()));
                      },
                    ),
                  );
                }else{
                  return Container();
                }

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
