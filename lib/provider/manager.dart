import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class Manager with ChangeNotifier {
  List<String> ports = [];
  String? port;
  void updatePorts(){
    ports = SerialPort.availablePorts;
    notifyListeners();
  }
  void selectPort(String portName){
    port = portName;
    print(port);
    notifyListeners();
  }
}