import 'dart:ffi';
// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
import 'package:hive/hive.dart';

part 'player.g.dart';

@HiveType(typeId: 0)
class Player extends HiveObject{
  @HiveField(0)
  final Int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String cpf;  
  @HiveField(3)
  final String sexo;
  @HiveField(4)
  final Float peso;
  @HiveField(5)
  final Float altura;
  @HiveField(6)
  final String sport;
  @HiveField(7)
  final String posicao;
  @HiveField(8)
  final String observacao;

  Player({required this.id, required this.name, required this.cpf, required this.sexo, required this.peso, required this.altura, required this.sport, required this.posicao, required this.observacao});

  
}