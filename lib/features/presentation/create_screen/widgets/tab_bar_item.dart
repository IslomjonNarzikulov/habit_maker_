import 'package:flutter/material.dart';
import 'package:path/path.dart';

Widget tabBar(
    TabController? tabController, void Function(int) tabBarChanging, BuildContext context) {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Theme.of(context).colorScheme.background),
    margin:const EdgeInsets.all(12),
    child: TabBar(
        onTap: (index) {
          tabBarChanging(index);
        },
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.blue),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        controller: tabController,
        tabs: const [
          Tab(
            child: Center(
              child: Text('Daily'),
            ),
          ),
          Tab(
            child: Center(
              child: Text('Weekly'),
            ),
          )
        ]),
  );
}
