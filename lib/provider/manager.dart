import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class Manager with ChangeNotifier {
  String _sport = '';
  String _func = 'Accel';
  List<String> ports = [];
  String? port;
  int _battery = 0;

  String get func => _func;
  String get sport => _sport;

  int get battery => _battery;

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
