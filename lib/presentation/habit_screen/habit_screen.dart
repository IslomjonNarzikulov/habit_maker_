import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/presentation/habit_screen/habit_provider/habit_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/kdays.dart';


class HabitScreen extends StatelessWidget {
  HabitModel habitModel;
  HabitScreen({super.key, required this.habitModel});

  late HabitPage provider;
  DateTime selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HabitPage>(context, listen: false);
    provider.initSelectedHabit(habitModel);
    return Consumer<HabitPage>(
        builder: (BuildContext context, HabitPage value, Widget? child) =>
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white54,
                title: Text(provider.title),
                actions: [
                  IconButton(
                    onPressed: () {
                      provider.deleteHabits(habitModel);
                      context.pop();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  IconButton(
                      onPressed: () {
                        context.go('/home/create', extra: habitModel);
                      },
                      icon: const Icon(Icons.edit))
                ],
              ),
              body: Column(
                children: [
                  TableCalendar(
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    daysOfWeekStyle: const DaysOfWeekStyle(
                        weekendStyle: TextStyle(color: Colors.red)),
                    calendarStyle: CalendarStyle(
                        weekendTextStyle: const TextStyle(color: Colors.red),
                        todayDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xff3939f6),
                          ),
                        ),
                        todayTextStyle: const TextStyle(color: Colors.black)),
                    headerStyle: const HeaderStyle(
                        formatButtonVisible: false, titleCentered: true),
                    selectedDayPredicate: (day) {
                      return provider.isDaySelected( day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      provider.onDaySelected(selectedDay, focusedDay);
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    rowHeight: 60,
                    weekNumbersVisible: false,
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ));
  }

// Future<void> navigateToUpdatePage(
//     BuildContext context, HabitModel habitModel) async {
//   final route = MaterialPageRoute(
//       builder: (context) => CreateScreen(
//             habitModel: habitModel,
//           ));
//   await Navigator.pushReplacement(context, route);
// }
}