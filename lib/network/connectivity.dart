

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:habit_maker/database/db_helper.dart';

class OfflineWidget extends StatefulWidget {
  @override
  _OfflineWidgetState createState() => _OfflineWidgetState();
}

class _OfflineWidgetState extends State<OfflineWidget> {
  late Connectivity _connectivity;
  late ConnectivityResult _connectionStatus;
  late DBHelper _dbHelper;

  @override
  void initState() {
    super.initState();

    _connectivity = Connectivity();
    // _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    //
    // _initializeDatabase();
    // _checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}