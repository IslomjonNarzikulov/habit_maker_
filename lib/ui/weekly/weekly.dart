import 'package:flutter/material.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:provider/provider.dart';

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
          title: const Text('Weekly'),
        ),
        body: Center(child: Consumer<HabitProvider>(
          builder: (BuildContext context, HabitProvider value, Widget? child) {
            var habit = value.habits;
            if (value.habits.isNotEmpty) {
              return ListView.builder(
                itemCount: habit.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.blue),
                      height: 95,
                      width: 360,
                      child: Column(
                        children: [
                          Text(habit[index].title.toString()),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 7,
                              itemBuilder: (context, dayIndex) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      isChecked[dayIndex] = !isChecked[dayIndex];
                                    }),
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: isChecked[dayIndex]
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ));
                },
              );
            } else {
              return Container();
            }
          },
        )));
  }
}
