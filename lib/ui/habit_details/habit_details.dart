import 'package:flutter/material.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/ui/create_habit/create_provider.dart';
import 'package:habit_maker/ui/habit_details/habit_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/kdays.dart';
import '../create_habit/create_habit.dart';

class HabitDetails extends StatefulWidget {
  final HabitModel item;

  const HabitDetails({Key? key, required this.item}) : super(key: key);

  @override
  State<HabitDetails> createState() => _HabitDetailsState();
}

class _HabitDetailsState extends State<HabitDetails> {
  late HabitPage provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<HabitPage>(context, listen: false);
  }

  DateTime selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    provider.initCalendarData(widget.item);
    return Consumer<HabitPage>(
        builder: (BuildContext context, HabitPage value, Widget? child) =>
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white54,
                title: Text(widget.item.title!),
                actions: [
                  IconButton(
                    onPressed: () {
                      provider.deleteHabits(widget.item);
                      Navigator.pop(context);
                      final filtered = provider.habits
                          .where(
                              (element) => element.dbId != widget.item.dbId)
                          .toList();
                      setState(() {
                        provider.habits = filtered;
                      });
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  IconButton(
                      onPressed: () {
                       provider.navigateToUpdatePage(widget.item,context);
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
                    weekendTextStyle:
                    const TextStyle(color: Colors.red),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(
                          0xff3939f6
                        ),
                      ),
                    ),
                    todayTextStyle:
                    const TextStyle(color: Colors.black)),
                headerStyle: const HeaderStyle(
                    formatButtonVisible: false, titleCentered: true),
                selectedDayPredicate: (day) {
                  return provider.isDaySelected(day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  provider.onDaySelected(
                      selectedDay, focusedDay,widget.item);
                },
                    onPageChanged: (focusedDay){
                  _focusedDay=focusedDay;
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
            )
    );
  }

}
