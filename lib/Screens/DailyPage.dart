import 'package:flutter/material.dart';
import 'package:habit_maker/Screens/CreateHabit.dart';
import 'package:habit_maker/Screens/Settings.dart';
import 'package:habit_maker/Screens/habit_details.dart';
import 'package:habit_maker/Screens/profile.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:provider/provider.dart';
import '../login/signIn.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  late HabitProvider provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<HabitProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) =>  CreateHabit(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
            title: const Text('Habit Tracker'),
            backgroundColor: Colors.black,

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
                    provider.removeToken();
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
           child: Consumer<HabitProvider>(builder: (BuildContext context, HabitProvider value, Widget? child) {
           var habit = value.habits;
           if (value.habits.isNotEmpty) {
            return ListView.builder(
              itemCount: habit.length,
              itemBuilder: (context, int index) {
                var item=habit[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>  HabitDetails(item: item,),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    height: 76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 39, 39, 103),
                    ),
                    margin:const EdgeInsets.all(5),
                    child: ListTile(
                      title: Text(
                        habit[index].title.toString(),
                        style:const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        habit[index].description.toString(),
                        style:const TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                );
              },
            );
           } else {
            return const Center(
              child: Text('No data added yet'),
            );
          }
        },
      ),
    ));
  }
}
