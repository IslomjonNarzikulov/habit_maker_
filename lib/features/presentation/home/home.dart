import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/features/presentation/daily_screen/daily_screen.dart';
import 'package:habit_maker/features/presentation/home/home_provider.dart';
import 'package:habit_maker/features/presentation/home/widgets/list_tile_item.dart';
import 'package:habit_maker/features/presentation/weekly_screen/weekly.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  static final List<Widget> _widgetOptions = <Widget>[DailyScreen(), Weekly()];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeProvider provider;

  int _selectedIndex = 0;
  bool isDark = false;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomeProvider>(context, listen: false);
    provider.isLogged();
    provider.syncData();
    print('home:${provider.loggedState.toString()}');
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white60,
          actions: [
            IconButton(
              onPressed: () {
                context.push('/home/create');
              },
              icon: const Icon(Icons.add),
            ),
            IconButton(onPressed: (){}, icon: Icon(Icons.bar_chart))
          ],
          title: const Text('Habit Tracker'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              listItem(Icons.person, 'Profile', () {
                context.push('/home/profile');
              }),
              listItem(Icons.approval_outlined, 'More apps', () {moreApps();}),
              listItem(Icons.star_border, 'Rate us', () {rateURl();
              }),
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
  rateURl() async {
    final Uri url = Uri.parse(
        "https://play.google.com/store/apps/details?id=com.akramovv.meme");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
  moreApps() async {
    final Uri url = Uri.parse(
        "https://play.google.com/store/apps/dev?id=7296467308517793885");
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
