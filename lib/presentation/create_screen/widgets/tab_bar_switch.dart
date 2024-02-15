import 'package:flutter/material.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/models/hive_habit_model.dart';
import 'package:habit_maker/presentation/create_screen/create_provider/create_provider.dart';

Widget tabBarSwitch(
    CreateProvider provider, TabController? tabController, Repetition repetition) {
  return SizedBox(
    height: 110,
    child: TabBarView(
      controller: tabController,
      children: [
        Column(
          children: [
            const Text(
              'Repeat in these days',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Row(
                  children: List<Widget>.generate(
                    7,
                    (index) {
                      var item =repetition.weekdays![index];
                      return GestureDetector(
                        onTap: () {
                          provider.changeButtonColors(index, repetition);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: item.isSelected == true
                                ? Colors.amberAccent
                                : Colors.blueGrey,
                            radius: 18,
                            child: Text(
                              '${repetition.weekdays![index].weekday?.name[0]}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.all(12),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      'Frequency',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${provider.repetition.numberOfDays} times a week',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 30),
                    padding: const EdgeInsets.only(left: 90),
                    width: 240,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            provider.subtract();
                          },
                          child: Container(
                            height: 26,
                            width: 28,
                            color: Colors.blue,
                            child: const Icon(Icons.remove),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          "${provider.repetition.numberOfDays}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            provider.add();
                          },
                          child: Container(
                            height: 26,
                            width: 28,
                            color: Colors.blue,
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ],
    ),
  );
}

