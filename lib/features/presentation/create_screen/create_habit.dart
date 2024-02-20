import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/core/common/extension.dart';
import 'package:habit_maker/features/data/models/habit_model.dart';
import 'package:habit_maker/features/presentation/create_screen/create_provider.dart';
import 'package:habit_maker/features/presentation/create_screen/widgets/change_color.dart';
import 'package:habit_maker/features/presentation/create_screen/widgets/save_item.dart';
import 'package:habit_maker/features/presentation/create_screen/widgets/tab_bar_item.dart';
import 'package:habit_maker/features/presentation/create_screen/widgets/tab_bar_switch.dart';
import 'package:habit_maker/features/presentation/create_screen/widgets/text_form_field.dart';
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

  @override
  void initState() {
    super.initState();
    createProvider = Provider.of<CreateProvider>(context, listen: false);
    final habit = widget.habitModel;
    if (habit != null) {
      createProvider.repetition = habit.repetition!;
      isEdit = true;
      titleController.text = habit.title!;
      createProvider.selectedColorIndex = habit.color!;
      _tabController = TabController(
        initialIndex: 0,
        length: 2,
        vsync: this,
      );
    } else {
      createProvider.repetition = Repetition(
          weekdays: defaultRepeat.map((day) => Day.copy(day)).toList(),
          numberOfDays: 0,
          notifyTime: null,
          showNotification: false);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    titleController.dispose();
    super.dispose();
  }

  final DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white38,
          title: Text(isEdit ? 'Update habits' : 'Create habits'),
        ),
        body: Consumer<CreateProvider>(
            builder: ((context, createProvider, child) {
          return DefaultTabController(
            length: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      textForm(titleController),
                      Gap(8),
                      changingColor(createProvider),
                      Gap(30),
                      tabBar(_tabController, (index) {
                        createProvider.tabBarChanging(index);
                      }),
                      tabBarSwitch(createProvider, _tabController,
                          createProvider.repetition),
                      const Gap(30),
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
                            Gap(12),
                            Visibility(
                              visible:
                                  createProvider.repetition.showNotification!,
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
                                  value: createProvider
                                      .repetition.showNotification!,
                                  activeColor: Colors.blueAccent,
                                  onChanged: (bool value) {
                                    createProvider.changeReminderState(value);
                                    createProvider.repetition.showNotification =
                                        value;
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
    return HabitModel(
        id: widget.habitModel?.id,
        title: titleController.text,
        dbKey: widget.habitModel?.dbKey,
        isSynced: true,
        repetition: createProvider.repetition,
        color: createProvider.selectedColorIndex);
  }
}
