import 'package:flutter/material.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:provider/provider.dart';

import '../../UI/create_habit/create_habit.dart';
import '../../common/colors.dart';

class Weekly extends StatefulWidget {
  const Weekly({Key? key}) : super(key: key);

  @override
  State<Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {
  late HabitProvider provider;
 List <bool> isChecked = [false,false,false,false,false,false,false];

  @override
  void initState() {
    super.initState();
    provider = Provider.of<HabitProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
          title: const Text('Weekly'),
        ),
        body: Center(child: Consumer<HabitProvider>(
          builder: (BuildContext context, HabitProvider value, Widget? child) {
            var habit = value.habits;//yorden
            if (value.habits.isNotEmpty) {
              return ListView.builder(
                itemCount: habit.length,
                itemBuilder: (context, index) {
                 var item = habit[index];
                 var _selectedIndex = 0;
                if (item.color != null) {
                  _selectedIndex = item.color!;
                  return Container(
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: colorList[_selectedIndex]
                      ),
                      height: 95,
                      width: 360,
                      child: Column(
                        children: [
                          Text(habit[index].title.toString(), style: TextStyle(fontSize: 20,color: Colors.white),),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: item.repetition!.weekdays!.length,
                              itemBuilder: (context, dayIndex) {
                                var day = item.repetition!.weekdays![dayIndex];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() {
                                          _changeButtonColor(index,dayIndex);
                                        }),
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: day.isSelected == true
                                          ? Colors.green
                                          : Colors.white54,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ));
                }
                },
              );
            } else {
              return Container();
            }
          },
        )));
  }
  void _changeButtonColor(int index,int dayIndex) {
    var selectedHabit = provider
        .habits[index];
    var selectedDay = selectedHabit.repetition!.weekdays![dayIndex];
    setState(() {
      if (selectedDay.isSelected ==
          true) {
        selectedDay
            .isSelected = false;
      } else {
        selectedDay.isSelected = true;
      }
    });
  }
}
