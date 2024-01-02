import 'package:flutter/material.dart';
import 'package:habit_maker/common/colors.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:provider/provider.dart';

import '../../login/signIn.dart';
import '../create_habit/create_habit.dart';
import '../habit_details/habit_details.dart';
import '../profile/profile.dart';
import '../settings/settings.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({Key? key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  late HabitProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<HabitProvider>(context, listen: false);
    // provider.loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
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
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
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
      body: Center(
        child: Consumer<HabitProvider>(builder:
            (BuildContext context, HabitProvider value, Widget? child) {
          var habit = value.habits;
          if (value.habits.isNotEmpty) {
            return ListView.builder(
              itemCount: habit.length,
              itemBuilder: (context, int index) {
                var item = habit[index];
                var _selectedIndex = 0;
                if (item.color != null) {
                  _selectedIndex = item.color!;
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HabitDetails(item: item),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    height: 76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colorList[_selectedIndex],
                    ),
                    margin: const EdgeInsets.all(5),
                    child: ListTile(
                      title: Text(
                        habit[index].title.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (value.habits.isEmpty && provider.isLoading) {
            return Center(
              child: Container(
                child: const Text('No data added yet'),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}
