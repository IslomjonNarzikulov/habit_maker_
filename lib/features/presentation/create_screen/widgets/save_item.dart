import 'package:flutter/material.dart';
import 'package:habit_maker/features/presentation/create_screen/create_provider.dart';

import '../../../data/models/habit_model.dart';

Widget saveButton(
    bool isEdit,
    CreateProvider provider,
   HabitModel body,
    BuildContext context,
    GlobalKey<FormState> formKey,
    void Function() updateHabits,
    void Function() createHabit) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        minimumSize: const Size(350, 55),
        backgroundColor: const Color(0xff309d9f)),
    onPressed: () {
      if (formKey.currentState?.validate() ?? false) {
        if (isEdit) {
          updateHabits();
        } else {
          createHabit();
        }
      }
    },
    child: Text(
      isEdit ? 'Update data' : 'Save Data',
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
    ),
  );
}
