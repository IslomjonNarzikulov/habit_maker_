import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/common/colors.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:table_calendar/table_calendar.dart';

List text = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

Widget weeklyDate(HabitModel habitModel, BuildContext context, int index,
    void Function(int, int) changeActivityState) {
  var selectedIndex = 0;
  if (habitModel.color != null) {
    selectedIndex = habitModel.color!;
  }
  return GestureDetector(
    onTap: () {
      context.push('/home/calendar', extra: habitModel);
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
              habitModel.title!,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            Container(
              width: 350,
              height: 20,
              alignment: Alignment.topRight,
              child: Text(
                '${habitModel.repetition!.numberOfDays} times a week',
                style: const TextStyle(color: Colors.white54),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(6),
                  scrollDirection: Axis.horizontal,
                  itemCount: text.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.only(right: 27),
                        child: Text(text[index]));
                  }),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, dayIndex) {
                  var difference = DateTime.now().weekday - 1 - dayIndex;
                  var date =
                      DateTime.now().subtract(Duration(days: difference));
                  var isDaySelected = habitModel.activities
                      ?.where((element) {
                        return isSameDay(DateTime.parse(element.date!), date) &&
                            element.isDeleted == false;
                      })
                      .toList()
                      .isNotEmpty;
                  bool isDisabled = difference < 0;
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: isDisabled
                          ? null
                          : () {
                              changeActivityState(index, dayIndex);
                            },
                      child: CircleAvatar(
                        backgroundColor: isDaySelected == true
                            ? Colors.white
                            : Colors.black54,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: isDaySelected == true
                              ? Colors.white
                              : Colors.transparent,
                          child: isDaySelected == true
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
