import 'package:hive/hive.dart';

part 'match.g.dart';

@HiveType(typeId: 2)
class Match extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  String date;

  @HiveField(4)
  String sport;

  @HiveField(5)
  int playerId;

  @HiveField(6)
  int fieldId;

  Match({required this.id, 
  required this.name, 
  required this.description, 
  required this.date,
  required this.sport,
  required this.playerId, 
  required this.fieldId});

}