import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:habit_maker/common/colors.dart';
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
  TabController? _tabController;
  final titleController = TextEditingController();
  late HabitProvider provider;
  bool isEdit = false;
  int _selectedIndex = 0;
  bool light = true;
  Repetition repeat = Repetition(
    notifyTime: '0',
    numberOfDays: 0,
    weekdays: defaultRepeat,
    showNotification: false,
  );

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
      final repetition =  habit.repetition;
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
              backgroundColor: Colors.green,
              title: Text(isEdit ? 'Update habits' : 'Create habits'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 75,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: titleController,
                        maxLength: 50,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          filled: true,
                          hintText: 'Enter title',
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
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
                                      radius: 16,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Reminder',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 12),
                          Visibility(
                            visible: light,
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
                                    color: Colors.grey),
                                child: Center(
                                  child: Text(
                                    _dateTime.hour.toString().padLeft(2, '0') +
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
                          Container(
                            child: Expanded(
                              child: SwitchListTile(
                                  value: light,
                                  onChanged: (bool value) {
                                    setState(() {
                                      light = value;
                                    });
                                  }),
                            ),
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
                              backgroundColor: Colors.green),
                          onPressed: () {
                            if (isEdit) {
                              var item = widget.habitModel;
                              if (item == null) {
                                return;
                              }
                              final id = item.id;
                              provider.updateHabits(id!, body);
                              Navigator.pop(context);
                            } else {
                              provider.createHabit(body);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            isEdit ? 'Update data' : 'Save Data',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
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
            icon: Icon(
              Icons.ac_unit_outlined,
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
                                : Colors.grey,
                            radius: 18,
                            child: Container(
                              child: Text(
                                  '${repeat.weekdays![index].weekday?.name[0]}'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              'heeey, it is snowing',
              style: TextStyle(fontSize: 35),
            ),
          )
        ],
      ),
    );
  }
}
