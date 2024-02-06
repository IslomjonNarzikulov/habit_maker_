import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:habit_maker/common/colors.dart';
import 'package:habit_maker/common/extension.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/presentation/create_screen/create_provider.dart';
import 'package:habit_maker/presentation/create_screen/widget_create_item/create_item.dart';
import 'package:habit_maker/presentation/habit_screen/habit_screen.dart';
import 'package:habit_maker/presentation/home/home.dart';
import 'package:provider/provider.dart';

class CreateScreen extends StatefulWidget {
  HabitModel? habitModel;

  CreateScreen({super.key, this.habitModel});

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
  int _selectedIndex = 0;
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
                                    provider.selectColor(_selectedIndex);
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
                    tabBarSwitch(_tabController!),
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
                                        children: [hourMinute12H()],
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
        floatingActionButton: saveButton());
  }

  HabitModel get body {
    final habitTitle = titleController.text;
    return HabitModel(
        id: widget.habitModel?.id,
        dbId: widget.habitModel?.dbId,
        title: habitTitle,
        isSynced: true,
        repetition: repeat,
        color: _selectedIndex);
  }

  Widget saveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(350, 55),
          backgroundColor: const Color(0xff309d9f)),
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          if (isEdit) {
            // var item = widget.habitModel;
            provider.updateHabits(body);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HabitScreen(habitModel: body)));
          } else {
            provider.createHabit(body);
            var route =
                MaterialPageRoute(builder: (context) => const HomeScreen());
            Navigator.pushReplacement(context, route);
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

  Widget tabBarSwitch(
      TabController? _tabController
      ) {
    return Container(
      height: 110,
      child: TabBarView(
        controller: _tabController,
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
                        var item = repeat.weekdays![index];
                        return GestureDetector(
                          onTap: () {
                            provider.changeButtonColors(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: item.isSelected == true
                                  ? Colors.amberAccent
                                  : Colors.blueGrey,
                              radius: 18,
                              child: Text(
                                '${repeat.weekdays![index].weekday?.name[0]}',
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
                        '${provider.numberOfDays} times a week',
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
                        child: Row(children: [
                          GestureDetector(
                            onTap: () {
                              provider.subtract(repeat);
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
                            "${provider.numberOfDays}",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          GestureDetector(
                            onTap: () {
                              provider.add(repeat);
                            },
                            child: Container(
                              height: 26,
                              width: 28,
                              color: Colors.blue,
                              child: const Icon(Icons.add),
                            ),
                          )
                        ])),
                  ),
                ]),
          )
        ],
      ),
    );
  }

  Widget hourMinute12H() {
    return TimePickerSpinner(
      is24HourMode: false,
      onTimeChange: (time) {
        provider.selectTime(time);
      },
    );
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
