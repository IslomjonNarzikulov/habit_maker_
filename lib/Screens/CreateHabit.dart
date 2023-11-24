import 'package:flutter/material.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:provider/provider.dart';

class CreateHabit extends StatefulWidget {
  HabitModel? habitModel;

  CreateHabit({super.key, this.habitModel});

  @override
  State<CreateHabit> createState() => _CreateHabitState();
}

class _CreateHabitState extends State<CreateHabit> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late HabitProvider provider;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    provider = context.read<HabitProvider>();
    final habit = widget.habitModel;
    if (habit != null) {
      isEdit = true;
      final title = habit.title;
      final description = habit.description;
      titleController.text = title!;
      descriptionController.text = description!;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  bool _reminder = false;
  bool? isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: ((context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(isEdit?'Update habits':'Create habits'),
        ),
            body: Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: TextField(
                      controller: titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        labelText: 'Enter title',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(7, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: index == 0
                                ? Colors.purpleAccent
                                : index == 1
                                    ? Colors.yellow
                                    : index == 2
                                        ? Colors.blue
                                        : index == 3
                                            ? Colors.blueGrey
                                            : index == 4
                                                ? Colors.green
                                                : index == 5
                                                    ? Colors.redAccent
                                                    : Colors.blueGrey,
                          ),
                        );
                      })),
                ),
                // const SizedBox(height: 36),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: List <Widget>.generate(7, (index) =>
                //       Padding(padding: const EdgeInsets.only(right:6),
                //       child: Checkbox(
                //         tristate: true,
                //         value: isChecked,
                //         onChanged: (bool? value) {
                //           setState(() {
                //             isChecked = value;
                //           });
                //         },
                //       ),
                //       )
                //   ),
                // ),

                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      SwitchListTile(
                          title: const Text('Reminder',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          value: _reminder,
                          onChanged: (bool value) {
                            setState(() {
                              _reminder = value;
                            });
                          })
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: isEdit?updateHabits:_saveHabit,
                      child:  Text(isEdit?'Update data':'Save Data'),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }

  Future<void> _saveHabit() async {
    final isSuccess = await provider.createHabit(body);
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit successfully saved')),
      );

      Navigator.pop(context);
      titleController.text = '';
      descriptionController.text = '';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save habit')),
      );
    }
  }

  HabitModel get body {
    final habitTitle = titleController.text;
    final habitDescription = descriptionController.text;
    return HabitModel(
      id: '',
      userId: '',
      title: habitTitle,
      description: habitDescription,
      createdAt: '',
      updatedAt: '',
      isSynced: true,
    );
  }

  Future<void> updateHabits() async {
    var item = widget.habitModel;
    if (item == null) {
      print('You cannot call without data');
      return;
    }
    final id = item.id;
    final isSuccess = await provider.updateHabits(id!, body);
    if (isSuccess) {
      Navigator.pop(context);
      print('Updation Success');
    } else {
      print('Updation Failed');
    }
  }
}
