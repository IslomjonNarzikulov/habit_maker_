import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/common/extension.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/presentation/create_screen/create_provider/create_provider.dart';
import 'package:habit_maker/presentation/create_screen/widgets/change_color.dart';
import 'package:habit_maker/presentation/create_screen/widgets/save_item.dart';
import 'package:habit_maker/presentation/create_screen/widgets/tab_bar_item.dart';
import 'package:habit_maker/presentation/create_screen/widgets/tab_bar_switch.dart';
import 'package:habit_maker/presentation/create_screen/widgets/text_form_field.dart';
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
  late CreateProvider createProvider;
  TabController? _tabController;
  bool light = true;
  bool isEnded = false;
  Repetition repeat = Repetition();

  @override
  void initState() {
    super.initState();
    createProvider = Provider.of<CreateProvider>(context, listen: false);
    final habit = widget.habitModel;
    _tabController = TabController(length: 2, vsync: this);
    if (habit != null) {
      repeat = habit.repetition!;
      final notifyTime = repeat.notifyTime?.split(':');
      if (notifyTime != null && notifyTime.length == 2) {
        createProvider.dateTime = DateTime(
            createProvider.dateTime.year,
            createProvider.dateTime.month,
            createProvider.dateTime.day,
            int.parse(notifyTime[0]),
            int.parse(notifyTime[1]));
      }
      isEdit = true;
      titleController.text = habit.title!;
      createProvider.selectedIndex = habit.color!;
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
                    textForm(),
                    const SizedBox(height: 8),
                   changingColor(createProvider),
                    const SizedBox(height: 36),
                    tabBar(_tabController, (index) {
                      createProvider.tabBarChanging(index);
                    }),
                    tabBarSwitch(createProvider, _tabController, repeat),
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
                            visible: createProvider.isReminderEnabled,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (context) {
                                      return timeSpinner(createProvider);
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
                                value: createProvider.isReminderEnabled,
                                activeColor: Colors.blueAccent,
                                onChanged: (bool value) {
                                  createProvider.changeReminderState(value);
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
            saveButton(isEdit, createProvider, body, context, _formKey, () {
              createProvider.updateHabits(body);
          context.replace('/home/calendar', extra: body);
        }, () {
              createProvider.createHabit(body);
          context.pop();
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
        color: createProvider.selectedIndex);
  }
}

