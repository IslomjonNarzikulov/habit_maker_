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
        var habits = value.weekly;
        if (value.weekly.isNotEmpty) {
          return Stack(children: [
            RefreshIndicator(
              onRefresh: () async {
                provider.loadHabits();
                return Future<void>.delayed(const Duration(seconds: 2));
              },
              child: Container(
                child: ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    var item = habits[index];
                    var selectedIndex = 0;
                    if (item.color != null) {
                      selectedIndex = item.color!;
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
                                color: colorList[selectedIndex]),
                            height: 115,
                            width: 360,
                            child: Column(
                              children: [
                                Text(
                                  habits[index].title.toString(),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                Container(
                                  width: 350,
                                  height: 20,
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '${item.repetition!.numberOfDays} times a week',
                                    style:
                                        const TextStyle(color: Colors.white54),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      padding: EdgeInsets.all(6),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: text.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 27),
                                            child: Text(text[index]));
                                      }),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 7,
                                    itemBuilder: (context, dayIndex) {
                                      var difference =
                                          DateTime.now().weekday - 1 - dayIndex;
                                      var date = DateTime.now()
                                          .subtract(Duration(days: difference));
                                      var isDaySelected = item.activities
                                          ?.where((element) {
                                            return isSameDay(
                                                    DateTime.parse(
                                                        element.date!),
                                                    date) &&
                                                element.isDeleted == false;
                                          })
                                          .toList()
                                          .isNotEmpty;
                                      bool isDisabled = difference < 0;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
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
                                            backgroundColor:
                                                isDaySelected == true
                                                    ? Colors.white
                                                    : Colors.black54,
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                                  isDaySelected == true
                                                      ? Colors.white
                                                      : Colors.transparent,
                                              child: isDaySelected == true
                                                  ? const Icon(
                                                      Icons.check,
                                                      color: Colors.black,
                                                      size: 16,
                                                    )
                                                  : CircleAvatar(
                                                      backgroundColor:
                                                          isDisabled
                                                              ? Colors.grey[100]
                                                              : const Color(
                                                                  0x0fffffff),
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
              ),
            ),
            if (provider.isLoading)
              Container(
                color: Colors.transparent.withOpacity(0.5),
                child: Center(child: CircularProgressIndicator()),
              )
          ]);
        } else {
          return Container();
        }
      },
    )));
  }

  void _changeButtonColor(int index, int dayIndex) {
    var difference = DateTime.now().weekday - 1 - dayIndex;
    var selectedHabit = provider.weekly[index];
    var date = DateTime.now().subtract(Duration(days: difference));
    var isDaySelected = selectedHabit.activities?.where((element) {
      return isSameDay(DateTime.parse(element.date!), date) &&
          element.isDeleted == false;
    }).isNotEmpty;
    if (isDaySelected == false) {
      provider.createActivities(selectedHabit, date);
    } else {
      provider.deleteActivities(selectedHabit, date);
    }
  }
}
