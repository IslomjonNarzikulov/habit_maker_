import 'package:flutter/material.dart';
import 'package:habit_maker/Screens/CreateHabit.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitDetails extends StatefulWidget {
  final HabitModel item;

  HabitDetails({Key? key, required this.item}) : super(key: key);

  @override
  State<HabitDetails> createState() => _HabitDetailsState();
}

class _HabitDetailsState extends State<HabitDetails> {
  late HabitProvider provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<HabitProvider>();
  }

  DateTime today = DateTime.now();
  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer <HabitProvider>(
      builder: (BuildContext context, HabitProvider value, Widget? child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(widget.item.title!),
            actions: [
              IconButton(
                onPressed: () {
                  deleteHabit();
                },
                icon: const Icon(Icons.delete),
              ),
              const SizedBox(
                width: 12,
              ),
              IconButton(
                  onPressed: () {
                    navigateToUpdatePage(widget.item);
                  },
                  icon: const Icon(Icons.edit))
            ],
          ),
          body: Column(
            children: [
              Container(
                child: const Row(
                  children: [
                    SizedBox(width: 92),
                    Text('Total'),
                    SizedBox(width: 36),
                    Text('Streak'),
                    SizedBox(
                      width: 36),
                    Text('Score'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TableCalendar(
                focusedDay: selectedDay,
                firstDay: DateTime.utc(2020, 2, 2),
                lastDay: DateTime.utc(2030, 2, 2),
                onDaySelected: (DateTime selectDay, DateTime focusDay) {
                  setState(() {
                    selectedDay = selectDay;
                  });
                  print(selectDay);
                },
                selectedDayPredicate: (DateTime date) {
                  return isSameDay(selectedDay, date);
                },
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
      )
    );
  }

  Future<void> deleteHabit() async {
    final isSuccess = await provider.deleteHabits(widget.item.id!);
    if (isSuccess) {
      Navigator.pop(context);

      final filtered = provider.habits
          .where((element) => element.id == widget.item.id)
          .toList();
      setState(() {
        provider.habits = filtered;
      });

      print('Deletion Success');
    } else {
      print('Deletion failed');
    }
  }

  Future<void> navigateToUpdatePage(HabitModel habitModel) async {
    final route = MaterialPageRoute(
        builder: (context) => CreateHabit(
              habitModel: habitModel,
            ));
    await Navigator.push(context, route);
  }
}
