import 'package:flutter/material.dart';
import 'package:habit_maker/core/common/colors.dart';
import 'package:habit_maker/features/presentation/create_screen/create_provider.dart';

Widget changingColor(CreateProvider createProvider){
  return  Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
        'Colors',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 14),
      Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(
              7,
                  (index) {
                return GestureDetector(
                  onTap: () {
                    createProvider.selectColor(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.5),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: colorList[index],
                      child: createProvider.selectedColorIndex == index
                          ? const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ],
  );
}