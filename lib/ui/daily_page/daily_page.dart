import 'package:flutter/material.dart';
import 'package:habit_maker/common/colors.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:provider/provider.dart';

import '../habit_details/habit_details.dart';

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
    provider.loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<HabitProvider>(builder:
            (BuildContext context, HabitProvider value, Widget? child) {
          var habit = value.habits;
          if (value.habits.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                provider.loadHabits();
                return Future<void>.delayed(const Duration(seconds: 2));
              },
              child: ListView.builder(
                itemCount: habit.length,
                itemBuilder: (context, int index) {
                  var item = habit[index];
                  var _selectedIndex = 0;
                  if (item.color != null) {
                    _selectedIndex = item.color!;
                  }
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart ||
                          direction == DismissDirection.startToEnd) {
                        var date = DateTime.now();
                        provider.createActivities(item, date);
                      }
                    },
                    child: GestureDetector(
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
                          title: Center(
                            child: Text(
                              habit[index].title.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 22),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (value.habits.isEmpty) {
            return Center(
              child: Container(
                  alignment: Alignment.center,
                  child: const Text('No data added yet')),
            );
          } else {
            return const CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}
