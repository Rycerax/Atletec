import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:hive/hive.dart';
import 'package:atletec/model/player.dart';
import 'package:atletec/model/field.dart';
import 'package:atletec/model/match.dart';

class Manager with ChangeNotifier {
  String _sport = '';
  String _func = 'Accel';
  List<String> ports = [];
  String? port;
  int _battery = 0;
  Player? _selectedPlayer;
  Field? _selectedField;
  Match? _selectedMatch;

  late Box<Player> _playerBox;
  late Box<Field> _fieldBox;
  late Box<Match> _matchBox;

  Manager() {
    _init();
  }

  Future<void> _init() async {
    _playerBox = await Hive.openBox<Player>('players');
    _fieldBox = await Hive.openBox<Field>('fields');
    _matchBox = await Hive.openBox<Match>('matches');
  }

  List<Player> get players => _playerBox.values.toList();
  List<Field> get fields => _fieldBox.values.toList();
  List<Match> get matches => _matchBox.values.toList();

  Player? get selectedPlayer => _selectedPlayer;
  Field? get selectedField => _selectedField;
  Match? get selectedMatch => _selectedMatch;

  String get func => _func;
  String get sport => _sport;

  int get battery => _battery;

  void addPlayer(Player player) {
    _playerBox.add(player);
    notifyListeners();
  }

  void removePlayer(int id) {
    final player = _playerBox.values.firstWhere((player) => player.id == id);
    player.delete();
    _selectedPlayer = null;
    notifyListeners();
  }

  void updatePlayer(Player updatedPlayer) {
    final player = _playerBox.values.firstWhere((player) => player.id == updatedPlayer.id);
    player.name = updatedPlayer.name;
    player.cpf = updatedPlayer.cpf;
    player.sexo = updatedPlayer.sexo;
    player.peso = updatedPlayer.peso;
    player.altura = updatedPlayer.altura;
    player.sport = updatedPlayer.sport;
    player.posicao = updatedPlayer.posicao;
    player.observacao = updatedPlayer.observacao;
    player.save();
    notifyListeners();
  }

  void selectPlayer(Player player) {
    _selectedPlayer = player;
    notifyListeners();
  }

  int getNextPlayerId() {
    if (_playerBox.isEmpty) {
      return 1;
    } else {
      return _playerBox.values.map((player) => player.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  void addField(Field field) {
    _fieldBox.add(field);
    notifyListeners();
  }

  void removeField(int id) {
    final field = _fieldBox.values.firstWhere((field) => field.id == id);
    field.delete();
    _selectedField = null;
    notifyListeners();
  }

  void updateField(Field updatedField) {
    final field = _fieldBox.values.firstWhere((field) => field.id == updatedField.id);
    field.coordinates = updatedField.coordinates;
    field.name = updatedField.name;
    field.save();
    notifyListeners();
  }

  void selectField(Field field) {
    _selectedField = field;
    notifyListeners();
  }

  int getNextFieldId() {
    if (_fieldBox.isEmpty) {
      return 1;
    } else {
      return _fieldBox.values.map((field) => field.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  void addMatch(Match match) {
    _matchBox.add(match);
    notifyListeners();
  }

  void removeMatch(int id) {
    final match = _matchBox.values.firstWhere((match) => match.id == id);
    match.delete();
    _selectedMatch = null;
    notifyListeners();
  }

  void updateMatch(Match updatedMatch) {
    final match = _matchBox.values.firstWhere((match) => match.id == updatedMatch.id);
    match.field = updatedMatch.field;
    match.name = updatedMatch.name;
    match.description = updatedMatch.description;
    match.player = updatedMatch.player;
    match.save();
    notifyListeners();
  }

  void selectMatch(Match? match) {
    _selectedMatch = match;
    notifyListeners();
  }

  int getNextMatchId() {
    if (_matchBox.isEmpty) {
      return 1;
    } else {
      return _matchBox.values.map((match) => match.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  void updateFunc(String fun) {
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
