import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/common/colors.dart';
import 'package:habit_maker/presentation/habit_screen/habit_screen.dart';
import 'package:habit_maker/presentation/main_provider.dart';
import 'package:provider/provider.dart';

class DailyScreen extends StatelessWidget {
  DailyScreen({super.key});
  late MainProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MainProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Consumer<MainProvider>(
            builder: (BuildContext context, MainProvider value, Widget? child) {
          var habit = value.habits;
          if (value.habits.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await provider.loadHabits();
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
                      var date = DateTime.now();
                      provider.createActivities(item, [date]);
                    },
                    movementDuration: Duration(milliseconds: 0),
                    direction: DismissDirection.horizontal,
                    child: GestureDetector(
                      onTap: () {
                        context.push('/home/calendar',extra: item);
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
