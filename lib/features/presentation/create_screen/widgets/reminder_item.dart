import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:habit_maker/core/common/extension.dart';
import 'package:habit_maker/features/presentation/create_screen/create_provider.dart';

Widget reminder(
    CreateProvider createProvider, BuildContext context, DateTime dateTime) {
  return Container(
    margin: const EdgeInsets.all(12),
    height: 36,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Reminder',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 12),
        Visibility(
          visible: createProvider.repetition.showNotification!,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (context) {
                    return TimePickerSpinner(
                      is24HourMode: false,
                      onTimeChange: (time) {
                        createProvider.selectTime(time);
                      },
                    );
                  });
            },
            child: Container(
              height: 30,
              width: 65,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blueGrey),
              child: Center(
                child: Text(
                  dateTime.toHHMM(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SwitchListTile(
              value: createProvider.repetition.showNotification!,
              activeColor: Colors.blueAccent,
              onChanged: (bool value) {
                createProvider.changeReminderState(value);
                createProvider.repetition.showNotification = value;
              }),
        ),
      ],
    ),
  );
}
