// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_habit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveHabitModelAdapter extends TypeAdapter<HiveHabitModel> {
  @override
  final int typeId = 0;

  @override
  HiveHabitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveHabitModel(
      id: fields[0] as String?,
      hiveRepetition: fields[2] as HiveRepetition?,
      color: fields[3] as int?,
      isDeleted: fields[4] as bool?,
      activities: (fields[6] as List?)?.cast<HiveActivities>(),
      isSynced: fields[5] as bool?,
      title: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveHabitModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.hiveRepetition)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.isDeleted)
      ..writeByte(5)
      ..write(obj.isSynced)
      ..writeByte(6)
      ..write(obj.activities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveHabitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveRepetitionAdapter extends TypeAdapter<HiveRepetition> {
  @override
  final int typeId = 1;

  @override
  HiveRepetition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveRepetition(
      id: fields[4] as String?,
      numberOfDays: fields[0] as int?,
      notifyTime: fields[1] as DateTime?,
      showNotification: fields[2] as bool?,
      weekdays: (fields[3] as List?)?.cast<HiveDay>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveRepetition obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.numberOfDays)
      ..writeByte(1)
      ..write(obj.notifyTime)
      ..writeByte(2)
      ..write(obj.showNotification)
      ..writeByte(3)
      ..write(obj.weekdays)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveRepetitionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveDayAdapter extends TypeAdapter<HiveDay> {
  @override
  final int typeId = 2;

  @override
  HiveDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveDay(
      weekday: fields[0] as int?,
      isSelected: fields[1] as bool?,
    )..id = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, HiveDay obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.weekday)
      ..writeByte(1)
      ..write(obj.isSelected)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveActivitiesAdapter extends TypeAdapter<HiveActivities> {
  @override
  final int typeId = 3;

  @override
  HiveActivities read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveActivities(
      id: fields[0] as String?,
      date: fields[1] as String?,
      isDeleted: fields[2] as bool?,
      isSynced: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveActivities obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.isDeleted)
      ..writeByte(3)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveActivitiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
