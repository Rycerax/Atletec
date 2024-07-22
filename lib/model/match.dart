import 'package:hive/hive.dart';
import './player.dart';
import './field.dart';

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
  Player? player;

  @HiveField(5)
  Field? field;

  Match({required this.id, 
  required this.name, 
  required this.description, 
  required this.date,
  required this.player, 
  required this.field});

}