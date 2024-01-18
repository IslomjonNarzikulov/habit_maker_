import 'dart:async';

class LogOutState {
  var logOut = StreamController<bool>.broadcast();

  logOutState(){
    logOut.add(false);
  }
}

