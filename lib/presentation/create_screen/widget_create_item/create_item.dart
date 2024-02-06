import 'package:flutter/material.dart';

Widget tabBar(TabController? _tabController) {
  return SizedBox(
    width: 600,
    child: TabBar(labelColor: Colors.black, controller: _tabController, tabs: [
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



