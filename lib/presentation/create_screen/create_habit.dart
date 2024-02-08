import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/common/colors.dart';
import 'package:habit_maker/common/extension.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/presentation/create_screen/create_provider.dart';
import 'package:habit_maker/presentation/create_screen/widgets/tab_bar_item.dart';
import 'package:habit_maker/presentation/create_screen/widgets/save_item.dart';
import 'package:habit_maker/presentation/create_screen/widgets/tab_bar_switch.dart';
import 'package:provider/provider.dart';

class CreateScreen extends StatefulWidget {
  CreateScreen({super.key, this.habitModel});
  HabitModel? habitModel;

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  bool isEdit = false;
  late CreateProvider provider;
  TabController? _tabController;
  int selectedIndex = 0;
  bool light = true;
  bool isEnded = false;
  Repetition repeat = Repetition();

  @override
  void initState() {
    super.initState();
    provider = Provider.of<CreateProvider>(context, listen: false);
    final habit = widget.habitModel;
    _tabController = TabController(length: 2, vsync: this);
    if (habit != null) {
      repeat = habit.repetition!;
      final notifyTime = repeat.notifyTime?.split(':');
      if (notifyTime != null && notifyTime.length == 2) {
        provider.dateTime = DateTime(
            provider.dateTime.year,
            provider.dateTime.month,
            provider.dateTime.day,
            int.parse(notifyTime[0]),
            int.parse(notifyTime[1]));
      }
      isEdit = true;
      final title = habit.title;
      titleController.text = title!;
      final color = habit.color;
      provider.selectedIndex = color!;
      _tabController = TabController(
        initialIndex: 0,
        length: 2,
        vsync: this,
      );
    } else {
      repeat = Repetition(
          weekdays: defaultRepeat.map((day) => Day.copy(day)).toList(),
          numberOfDays: 0,
          notifyTime: "0",
          showNotification: false);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    titleController.dispose();
    super.dispose();
  }

  final DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white38,
          title: Text(isEdit ? 'Update habits' : 'Create habits'),
        ),
        body: Consumer<CreateProvider>(
            builder: ((context, createProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      height: 85,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          UpperCaseTextFormatter()
                        ],
                        controller: titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          filled: true,
                          hintText: 'Enter title',
                        ),
                        validator: (value) {
                          if (titleController.text.trim().isEmpty) {
                            return 'Invalid input';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
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
                                    provider.selectColor(index);

                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: colorList[index],
                                      child: provider.selectedIndex == index
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
                    ),
                    const SizedBox(height: 36),
                    tabBar(_tabController),
                    tabBarSwitch( provider,_tabController, repeat),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.all(12),
                      height: 36,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Reminder',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 12),
                          Visibility(
                            visible: provider.isReminderEnabled,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        children: [
                                          TimePickerSpinner(
                                            is24HourMode: false,
                                            onTimeChange: (time) {
                                              provider.selectTime(time);
                                            },
                                          )
                                        ],
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
                                    repeat.notifyTime =
                                        '${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SwitchListTile(
                                value: provider.isReminderEnabled,
                                activeColor: Colors.blueAccent,
                                onChanged: (bool value) {
                                  provider.changeReminderState(value);
                                  repeat.showNotification = value;
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        })),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            saveButton(isEdit, provider, body, context, _formKey, () {
          provider.updateHabits(body);
         context.replace('/home/calendar', extra: body);
        }, () {
          provider.createHabit(body);
          Navigator.pop(context);
        }));
  }

  HabitModel get body {
    final habitTitle = titleController.text;
    return HabitModel(
        id: widget.habitModel?.id,
        dbId: widget.habitModel?.dbId,
        title: habitTitle,
        isSynced: true,
        repetition: repeat,
        color: selectedIndex);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}
