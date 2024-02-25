import 'dart:async';

class LogOutState {
  var logOutEvent = StreamController<bool>.broadcast();

  logOutState(){
    logOutEvent.add(false);
  }
}

