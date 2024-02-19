int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 15, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month +150, kToday.day);