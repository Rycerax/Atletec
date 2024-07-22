import 'package:hive/hive.dart';

part 'field.g.dart';

@HiveType(typeId: 1)
class Field extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String coordinates;

  @HiveField(2)
  String name;

  Field({required this.id, required this.coordinates, required this.name});

}