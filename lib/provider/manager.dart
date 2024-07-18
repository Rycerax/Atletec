import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:hive/hive.dart';
import 'package:atletec/model/player.dart';
import 'package:atletec/model/field.dart';

class Manager with ChangeNotifier {
  String _sport = '';
  String _func = 'Accel';
  List<String> ports = [];
  String? port;
  int _battery = 0;

  late Box<Player> _playerBox;
  late Box<Field> _fieldBox;

  Manager() {
    _init();
  }

  Future<void> _init() async {
    _playerBox = Hive.box<Player>('players');
    _fieldBox = Hive.box<Field>('fields');
  }

  List<Player> get players => _playerBox.values.toList();
  List<Field> get fields => _fieldBox.values.toList();
  String get func => _func;
  String get sport => _sport;

  int get battery => _battery;

  void addPlayer(Player player) {
    _playerBox.add(player);
    notifyListeners();
  }

  void removePlayer(String id) {
    final player = _playerBox.values.firstWhere((player) => player.id == id);
    _playerBox.delete(player);
    notifyListeners();
  }

  void updatePlayer(Player updatedPlayer) {
    final player = _playerBox.values.firstWhere((player) => player.id == updatedPlayer.id);
    player.name = updatedPlayer.name;
    player.save();
    notifyListeners();
  }

  void addField(Field field) {
    _fieldBox.add(field);
    notifyListeners();
  }

  void removeField(String id) {
    final field = _fieldBox.values.firstWhere((field) => field.id == id);
    field.delete();
    notifyListeners();
  }

  void updateField(Field updatedField) {
    final field = _fieldBox.values.firstWhere((field) => field.id == updatedField.id);
    field.name = updatedField.name;
    field.save();
    notifyListeners();
  }

  void updateFunc(String fun){
    _func = fun;
    notifyListeners();
  }

  void updateSport(String spt) {
    _sport = spt;
    notifyListeners();
  }

  void updateBattery(int btt) {
    _battery = btt;
    notifyListeners();
  }

  void updatePorts() {
    ports = SerialPort.availablePorts;
    notifyListeners();
  }

  void selectPort(String portName) {
    port = portName;
    print(port);
    notifyListeners();
  }
}
