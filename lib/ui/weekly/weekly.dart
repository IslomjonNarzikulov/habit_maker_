import 'package:flutter/material.dart';
import 'package:habit_maker/UI/habit_details/habit_details.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/colors.dart';

class Weekly extends StatefulWidget {
  const Weekly({Key? key}) : super(key: key);

  @override
  State<Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {
  late HabitProvider provider;
  int numberOfDays = 7;
  List<bool> isChecked = [false, false, false, false, false, false, false];
  List text = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  bool isDisabled = false;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<HabitProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Consumer<HabitProvider>(
      builder: (BuildContext context, HabitProvider value, Widget? child) {
        var habit = value.habits;
        if (value.habits.isNotEmpty) {
          return Container(
            child: ListView.builder(
              itemCount: habit.length,
              itemBuilder: (context, index) {
                var item = habit[index];
                var _selectedIndex = 0;
                if (item.color != null) {
                  _selectedIndex = item.color!;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HabitDetails(item: item),
                        ),
                      );
                    },
                    child: Container(
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: colorList[_selectedIndex]),
                        height: 115,
                        width: 360,
                        child: Column(
                          children: [
                            Text(
                              habit[index].title.toString(),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Container(
                              width: 350,
                              height: 20,
                              alignment: Alignment.topRight,
                              child: Text(
                                '${item.repetition!.numberOfDays} times a week',
                                style: const TextStyle(color: Colors.white54),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.all(6),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: text.length,
                                  itemBuilder: (context, index) {

                                    return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 26),
                                        child: Text(text[index]));
                                  }),
                            ),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: item.repetition!.weekdays!.length,
                                itemBuilder: (context, dayIndex) {
                                  var day = item.repetition!.weekdays![dayIndex];

                                  // var difference =
                                  //     DateTime.now().weekday - 1 - dayIndex;
                                  // var date = DateTime.now()
                                  //     .subtract(Duration(days: difference));
                                  // var isDaySelected = item.activities
                                  //     ?.where((element) {
                                  //       return isSameDay(
                                  //           DateTime.parse(element.date!),
                                  //           date);
                                  //     })
                                  //     .toList()
                                  //     .isNotEmpty;
                                  // bool isDisabled = difference < 0;
                                  // print(isDisabled.toString());
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 9),
                                    child: GestureDetector(
                                      onTap: isDisabled
                                          ? null
                                          : () {
                                              setState(
                                                () {
                                                  _changeButtonColor(
                                                      index, dayIndex);
                                                },
                                              );
                                            },
                                      child: CircleAvatar(
                                        backgroundColor: day.isSelected == true
                                            ? Colors.transparent
                                            : Colors.black54,
                                        child: CircleAvatar(
                                          radius: 18,
                                          backgroundColor: day.isSelected == true
                                              ? Colors.blue
                                              : Colors.transparent,
                                          child: day.isSelected == true
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.black,
                                                  size: 16,
                                                )
                                              : CircleAvatar(
                                                  backgroundColor: isDisabled
                                                      ? Colors.grey[100]
                                                      : const Color(0x0fffffff),
                                                ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )),
                  );
                }
              },
            ),
          );
        } else {
          return Container();
        }
      },
    )));
  }

  void _changeButtonColor(int index, int dayIndex) {
    var selectedHabit = provider.habits[index];
    var selectedDay = selectedHabit.repetition!.weekdays![dayIndex];
    setState(() {
      if (selectedDay.isSelected == true) {
        selectedDay.isSelected = false;
      } else {
        selectedDay.isSelected = true;
      }
    });
  }
}
