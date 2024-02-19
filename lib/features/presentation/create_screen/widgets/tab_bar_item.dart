import 'package:flutter/material.dart';

Widget tabBar(
    TabController? tabController, void Function(int) tabBarChanging) {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.white54),
    margin:const EdgeInsets.all(12),
    child: TabBar(
        onTap: (index) {
          tabBarChanging(index);
        },
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.blue),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
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
