import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:habit_maker/common/colors.dart';
import 'package:habit_maker/common/constants.dart';
import 'package:habit_maker/common/extension.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:provider/provider.dart';

class CreateHabit extends StatefulWidget {
  HabitModel? habitModel;

  CreateHabit({super.key, this.habitModel});

  @override
  State<CreateHabit> createState() => _CreateHabitState();
}

class _CreateHabitState extends State<CreateHabit>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TabController? _tabController;
  final titleController = TextEditingController();
  late HabitProvider provider;
  bool isEdit = false;
  int _selectedIndex = 0;
  bool light = true;
  bool isEnded = false;
  int numberOfDays = 7;
  Repetition repeat = Repetition(
    notifyTime: '0',
    numberOfDays: 0,
    weekdays: defaultRepeat,
    showNotification: false,
  );

  void add() {
    setState(() {
      if (numberOfDays == 7) {
        isEnded == true;
      } else {
        numberOfDays++;
      }
      repeat.numberOfDays = numberOfDays;
    });
  }

  void subtract() {
    setState(() {
      if (numberOfDays == 1) {
        isEnded == true;
      } else {
        numberOfDays--;
      }
      repeat.numberOfDays = numberOfDays;
    });
  }

  @override
  void initState() {
    super.initState();
    provider = context.read<HabitProvider>();
    final habit = widget.habitModel;
    _tabController = TabController(length: 2, vsync: this);
    if (habit != null) {
      isEdit = true;
      final title = habit.title;
      final color = habit.color;
      final repetition = habit.repetition;
      titleController.text = title!;
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    titleController.dispose();
    super.dispose();
  }

  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: ((context, value, child) => Scaffold(
            appBar: AppBar(
              title: Text(isEdit ? 'Update habits' : 'Create habits'),
            ),
            body: Padding(
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
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            filled: true,
                            hintText: 'Enter title',
                          ),
                          validator: (value) {
                            if (titleController.text.trim().isEmpty ||
                                repeat.weekdays!.isEmpty) {
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
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: colorList[index],
                                        child: _selectedIndex == index
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
                      tabBar(),
                      tabBarSwitch(),
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
                              visible: repeat.showNotification!,
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
                                      repeat.notifyTime = _dateTime.hour
                                              .toString()
                                              .padLeft(2, '0') +
                                          ':' +
                                          _dateTime.minute
                                              .toString()
                                              .padLeft(2, '0'),
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
                                  value: repeat.showNotification!,
                                  activeColor: Colors.blueAccent,
                                  onChanged: (bool value) {
                                    setState(() {
                                      repeat.showNotification = value;
                                    });
                                  }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(350, 55),
                                backgroundColor: Color(0xff309d9f)),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (isEdit) {
                                  var item = widget.habitModel;
                                    provider.updateHabits(item!, body);
                                    Navigator.pop(context);
                                  } else {
                                    provider.createHabit(body);
                                    Navigator.pop(context);
                                  }
                                }
                            },
                            child: Text(
                              isEdit ? 'Update data' : 'Save Data',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget hourMinute12H() {
    return TimePickerSpinner(
      is24HourMode: false,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  void changeButtonColors(int index) {
    setState(() {
      if (repeat.weekdays![index].isSelected == false) {
        repeat.weekdays![index].isSelected = true;
      } else {
        repeat.weekdays![index].isSelected = false;
      }
    });
  }

  HabitModel get body {
    final habitTitle = titleController.text;
    return HabitModel(
        id: widget.habitModel?.id,
        title: habitTitle,
        isSynced: true,
        repetition: repeat,
        color: _selectedIndex);
  }

  Widget tabBar() {
    return Container(
      width: 600,
      child:
          TabBar(labelColor: Colors.black, controller: _tabController, tabs: [
        Container(
          width: 300,
          color: Colors.blue,
          child: const Tab(
            child: Text(
              'Daily',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        Container(
          width: 300,
          color: Colors.lightBlue,
          child: const Tab(
            child: Text(
              'Weekly',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ]),
    );
  }

  Widget tabBarSwitch() {
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
                            changeButtonColors(index);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: item.isSelected == true
                                  ? Colors.amberAccent
                                  : Colors.blueGrey,
                              radius: 18,
                              child: Container(
                                child: Text(
                                  '${repeat.weekdays![index].weekday?.name[0]}',
                                  style: TextStyle(color: Colors.white),
                                ),
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
            margin: EdgeInsets.all(12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Frequency',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$numberOfDays times a week',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 30),
                        padding: EdgeInsets.only(left: 90),
                        width: 240,
                        child: Row(children: [
                          GestureDetector(
                            onTap: () {
                              subtract();
                            },
                            child: Container(
                              height: 26,
                              width: 28,
                              color: Colors.blue,
                              child: Icon(Icons.remove),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            "$numberOfDays",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          GestureDetector(
                            onTap: () {
                              add();
                            },
                            child: Container(
                              height: 26,
                              width: 28,
                              color: Colors.blue,
                              child: Icon(Icons.add),
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
}
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}
String capitalize(String value) {
  if(value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}