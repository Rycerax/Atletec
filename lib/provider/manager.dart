import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:atletec/model/player.dart';
import 'package:atletec/model/field.dart';
import 'package:atletec/model/match.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:atletec/model/metricModel.dart';
import 'package:atletec/provider/data_processor.dart';

class Manager with ChangeNotifier {
  String _sport = '';
  String _func = 'Metrics';
  String? port;
  int _battery = 0;
  bool _gps = false;

  Player? _selectedPlayer;
  Field? _selectedField;
  Match? _selectedMatch;

  bool _isMatch = false;
  
  late Box<Player> _playerBox;
  late Box<Field> _fieldBox;
  late Box<Match> _matchBox;


  final List<MetricModel> _metrics = [];  
  List<MetricModel> get metrics => List.unmodifiable(_metrics);

  final DataProcessor _processor = DataProcessor();
  DataPacket pacote_atual = DataPacket(timestamp: DateTime.now(), xg: 0, yg: 0, zg: 0, xa: 0, ya: 0, za: 0, latitude: 0, longitude: 0);
  PacketResult metricsPack = PacketResult(velocityMS: 0, velocityKMH: 0, accelerationMS2: 0, totalDistance: 0, timeStep: 0, band4Distance: 0, band5Distance: 0);

  get processor => _processor;
  Manager() {
    _init();
    _addDefaultMetrics();
  }

  Future<void> _init() async {
    Hive.registerAdapter(MatchAdapter());
    _playerBox = await Hive.openBox<Player>('players');
    _fieldBox = await Hive.openBox<Field>('fields');
    _matchBox = await Hive.openBox<Match>('matches');
    notifyListeners();
  }

  void _addDefaultMetrics() {
    if (_metrics.any((m) => m.name == "Aceleração m/s²")) return;

    _metrics.add(MetricModel(name: "Aceleração (m/s²)", unitMeasure: "m/s²"));
    _metrics.add(MetricModel(name: "Velocidade (m/s)", unitMeasure: "m/s"));
    _metrics.add(MetricModel(name: "Velocidade (km/h)", unitMeasure: "km/h"));
    _metrics.add(MetricModel(name: "Distância Total (m)", unitMeasure: "m"));
    _metrics.add(MetricModel(name: "Distância na Faixa 4 (m)", unitMeasure: "m"));
    _metrics.add(MetricModel(name: "Distância na Faixa 5 (m)", unitMeasure: "m"));

    notifyListeners(); 
  }

  List<Player> get players {
    final playersList = _playerBox.values.toList();
    playersList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return playersList;
  }
  
  List<Field> get fields {
    final fieldsList = _fieldBox.values.toList();
    fieldsList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return fieldsList;
  } 
  
  List<Match> get matches => _matchBox.values.toList();


  Player? get selectedPlayer => _selectedPlayer;
  Field? get selectedField => _selectedField;
  Match? get selectedMatch => _selectedMatch;

  String get func => _func;
  String get sport => _sport;
  bool get isMatch => _isMatch;
  bool get gps => _gps; 
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

  Player getPlayerbyId(int id){
    return _playerBox.values.firstWhere((player) => player.id == id);
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

  Field getFieldbyId(int id){
    return _fieldBox.values.firstWhere((field) => field.id == id);
  }

  int getNextFieldId() {
    if (_fieldBox.isEmpty) {
      return 1;
    } else {
      return _fieldBox.values.map((field) => field.id).reduce((a, b) => a > b ? a : b) + 1;
    }
  }

  void addMatch(Match match) {
    print(_matchBox.isEmpty);
    _matchBox.add(match);
    notifyListeners();
    print(_matchBox.isEmpty);
  }

  void removeMatch(int id) {
    final match = _matchBox.values.firstWhere((match) => match.id == id);
    match.delete();
    _selectedMatch = null;
    notifyListeners();
  }

  void updateMatch(Match updatedMatch) {
    final match = _matchBox.values.firstWhere((match) => match.id == updatedMatch.id);
    match.fieldId = updatedMatch.fieldId;
    match.name = updatedMatch.name;
    match.description = updatedMatch.description;
    match.playerId = updatedMatch.playerId;
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

  void selectPort(String portName) {
    port = portName;
    print(port);
    notifyListeners();
  }

  void updatedIsMatch(bool isMatch){
    _isMatch = isMatch;
    notifyListeners();
  }

  void updateGPS(bool gps){
    _gps = gps;
    notifyListeners();
  }

// ---------------------------------------- //
// --------------- MÉTRICAS --------------- //
// ---------------------------------------- //



  void updateMetric(String name, double newValue) {
    final metric = _metrics.firstWhere(
      (m) => m.name == name,
    );
    metric.updateValue(newValue);
    notifyListeners();
  }

  void updateAllMetrics(DataPacket pack, String f){
    
    if(f == "gps"){
      pacote_atual.latitude = pack.latitude;
      pacote_atual.longitude = pack.longitude;
    } else{
      pacote_atual.xa = pack.xa;
      pacote_atual.ya = pack.ya;
      pacote_atual.za = pack.za;
      pacote_atual.xg = pack.xg;
      pacote_atual.yg = pack.yg;
      pacote_atual.zg = pack.zg;
    }

    metricsPack = processor.updateWithNewPacket(pack);

    for(final metric in _metrics){
      if(metric.name == "Aceleração (m/s²)"){
        metric.updateValue(metricsPack.accelerationMS2);
      } else if(metric.name == "Distância Total (m)"){
        metric.updateValue(metricsPack.totalDistance);
      } else if(metric.name == "Velocidade (km/h)"){
        metric.updateValue(metricsPack.velocityKMH);
      } else if(metric.name == "Velocidade (m/s)"){
        metric.updateValue(metricsPack.velocityMS);
      } else if(metric.name == "Distância na Faixa 4 (m)"){
        metric.updateValue(metricsPack.band4Distance);
      } else if(metric.name == "Distância na Faixa 5 (m)"){
        metric.updateValue(metricsPack.band5Distance);
      } 
    } 
    // findMetricByName("Aceleração m/s²") ;
    // findMetricByName("Distância Percorrida Total");
    // findMetricByName("Velocidade km/h");
    // findMetricByName("Velocidade m/s");
    // findMetricByName("Distância na Faixa 4");
    // findMetricByName("Distância na Faixa 5");
    notifyListeners();
  }

  void resetMetrics(){
    // for(final metric in _metrics){
    //   metric.history.clear();
    //   metric.lastValue = 0.0;
    //   metric.previousValue = 0.0;
    // }
    _metrics.clear();
    _addDefaultMetrics();
    _processor.resetProcessorMetrics();

    notifyListeners();
  }

}
