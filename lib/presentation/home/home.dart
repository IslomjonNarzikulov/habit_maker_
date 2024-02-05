import 'package:flutter/material.dart';
import 'package:habit_maker/presentation/analytics_screen/analytics.dart';
import 'package:habit_maker/presentation/create_screen/create_habit.dart';
import 'package:habit_maker/presentation/home/drawer.dart';
import 'package:habit_maker/presentation/main_provider.dart';
import 'package:provider/provider.dart';
import '../daily_screen/daily_screen.dart';
import '../weekly/weekly.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final List<Widget> _widgetOptions = <Widget>[
    DailyScreen(),
    Weekly(),
    AnalyticsPage(),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MainProvider provider;

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MainProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => CreateScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
        title: const Text('Habit Tracker'),
      ),
      drawer: const CustomDrawer(),
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
