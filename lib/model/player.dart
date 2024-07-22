import 'package:hive/hive.dart';

part 'player.g.dart';

@HiveType(typeId: 0)
class Player extends HiveObject{
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String cpf;  
  @HiveField(3)
  String sexo;
  @HiveField(4)
  double peso;
  @HiveField(5)
  double altura;
  @HiveField(6)
  String sport;
  @HiveField(7)
  String posicao;
  @HiveField(8)
  String observacao;

  Player({required this.id, required this.name, required this.cpf, required this.sexo, required this.peso, required this.altura, required this.sport, required this.posicao, required this.observacao});

}