import 'package:flutter/material.dart';
import 'package:habit_maker/common/colors.dart';
import 'package:habit_maker/presentation/create_screen/create_provider/create_provider.dart';

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
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 18,
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
    ],
  );
}