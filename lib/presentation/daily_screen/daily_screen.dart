import 'package:flutter/material.dart';
import 'package:habit_maker/presentation/daily_screen/widgets/dismissable.item.dart';
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
          if (provider.habits.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                await provider.loadHabits();
              },
              child: ListView.builder(
                itemCount: provider.habits.length,
                itemBuilder: (context, int index) {
                  var hiveHabitModel = provider.habits[index];
                  var selectedIndex = 0;
                  if (hiveHabitModel.color != null) {
                    selectedIndex = hiveHabitModel.color!;
                  }
                  return dismissItem(provider, hiveHabitModel, context);
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
