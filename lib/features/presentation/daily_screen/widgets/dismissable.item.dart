import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/core/common/colors.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';
import 'package:habit_maker/features/presentation/main_provider.dart';


Widget dismissItem(MainProvider provider, HabitModel habitModel,BuildContext context){
  int selectedIndex = 0;
  if (habitModel.color != null) {
    selectedIndex = habitModel.color!;
  }
  return Dismissible(
    key: UniqueKey(),
    onDismissed: (direction) {
      var date = DateTime.now();
      provider.createActivities(habitModel, [date]);
    },
    direction: DismissDirection.horizontal,
    child: GestureDetector(
      onTap: () {
        context.push('/home/calendar',extra: habitModel);
      },
      child: Container(
        width: 140,
        height: 76,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorList[selectedIndex],
        ),
        margin: const EdgeInsets.all(5),
        child: ListTile(
          title: Center(
            child: Text(
             habitModel.title!,
              style: const TextStyle(
                  color: Colors.white, fontSize: 22),
            ),
          ),
        ),
      ),
    ),
  );
}