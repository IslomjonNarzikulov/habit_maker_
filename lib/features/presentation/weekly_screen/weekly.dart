import 'package:flutter/material.dart';
import 'package:habit_maker/features/presentation/main_provider.dart';
import 'package:habit_maker/features/presentation/weekly_screen/widgets/weekly_date_item.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Weekly extends StatelessWidget {
  Weekly({super.key});

  late MainProvider provider;
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MainProvider>(context, listen: false);
    return Scaffold(body: Center(child: Consumer<MainProvider>(
      builder: (BuildContext context, MainProvider value, Widget? child) {
        var habits = value.weekly;
        if (value.weekly.isNotEmpty) {
          return Stack(children: [
            RefreshIndicator(
              onRefresh: () async {
                provider.loadHabits();
                return Future<void>.delayed(const Duration(seconds: 2));
              },
              child: ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, habitIndex) {
                    var item = habits[habitIndex];
                    return weeklyDate(item, context, habitIndex,
                        (habitIndex, dayIndex) {
                      _changeButtonColor(habitIndex, dayIndex);
                    });
                  }),
            ),
            if (provider.isLoadingState())
              Container(
                  color: Colors.transparent.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()))
          ]);
        } else if (provider.weekly.isEmpty) {
          return Container(
            child:
                const Text
                  ('No habits added yet.' 'Do you want to change it?'),
          );
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
      provider.createActivities(selectedHabit, [date]);
    } else {
      provider.deleteActivities(selectedHabit, [date]);
    }
  }
}
