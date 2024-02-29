import '../../arch_provider/arch_provider.dart';

class MainProvider extends BaseProvider {
  var loggedState = false;

  MainProvider(
    loginRepository,
    keeper,
    habitRepository,
    logoutState,
  ) : super(loginRepository, keeper, habitRepository, logoutState) {
    keeper.habitEvent.stream.listen((event) {
      habits = keeper.habits;
      weekly = keeper.weekly;
      notifyListeners();
    });
  }

  void logOut() {
    logoutState.logOutEvent.add(true);
    loggedState = false;
    loginRepository.logout();
    keeper.clear();
    notifyListeners();
  }

  Future<void> isLogged() async {
    var result = await loginRepository.isLogged();
    loggedState = result;
    notifyListeners();
  }

}
