import 'dart:ffi';

import 'package:hive/hive.dart';

part 'field.g.dart';

@HiveType(typeId: 1)
class Field extends HiveObject{
  @HiveField(0)
  final Int id;

  @HiveField(1)
  final String coordinates;

  @HiveField(2)
  final String name;

  Field({required this.id, required this.coordinates, required this.name});

}