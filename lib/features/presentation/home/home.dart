import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/features/presentation/analytics_screen/analytics.dart';
import 'package:habit_maker/features/presentation/daily_screen/daily_screen.dart';
import 'package:habit_maker/features/presentation/home/home_provider.dart';
import 'package:habit_maker/features/presentation/home/widgets/list_tile_item.dart';
import 'package:provider/provider.dart';
import '../weekly_screen/weekly.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

   static final List<Widget> _widgetOptions = <Widget>[
    DailyScreen(),
    Weekly()
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeProvider provider;

  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomeProvider>(context, listen: false);
    provider.isLogged();
    print('home:${provider.loggedState.toString()}');
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                context.push('/home/create');
              },
              icon: const Icon(Icons.add),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.home_outlined))
          ],
          title: const Text('Habit Tracker'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              listItem(Icons.person, 'Profile', () {
                context.push('/home/profile');
              }),
              listItem(Icons.settings, 'Settings', () {
                context.push('/home/settings');
              }),
              listItem(Icons.approval_outlined, 'More apps', () {}),
              provider.loggedState == true
                  ? ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Log out'),
                      onTap: () {
                        provider.logOut();
                        print('logged out');
                        Navigator.pop(context);
                      },
                    )
                  : listItem(Icons.logout_outlined, 'Login', () {
                      context.replace('/login');
                    }),
            ],
          ),
        ),
        body:
            Center(child: HomeScreen._widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.line_weight_sharp), label: 'Daily'),
            BottomNavigationBarItem(
                icon: Icon(Icons.view_week_outlined), label: 'Weekly'),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.bar_chart), label: 'Analytics'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber,
          onTap: onItemTapped,
        ),
      );
    });
  }
}
