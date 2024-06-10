import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'dart:async';

class Manager with ChangeNotifier {
  SerialPort? port;
  List<String> ports = [];

  void initSerialPort(String portName) {
    port = SerialPort(portName);
    if(port != null && !port!.openReadWrite()){
      print(SerialPort.lastError);
      return;
    }

    final config = SerialPortConfig();
    config.baudRate = 115200;
    port?.config = config;
  }

  Future<List<int>> readUntilByte(SerialPort? port, int stopByte) async {
    if (port == null) {
      throw Exception("Serial port is not initialized");
    }

    final reader = SerialPortReader(port);
    final completer = Completer<List<int>>();
    final buffer = <int>[];

    StreamSubscription<List<int>>? subscription; // Declare as nullable

    subscription = reader.stream.listen((data) {
      for (final byte in data) {
        buffer.add(byte);
        if (byte == stopByte) {
          subscription?.cancel(); // Use nullable access
          completer.complete(buffer);
          return;
        }
      }
    });

    return completer.future;
  }

  void readData() async {
    try {
      final data = await readUntilByte(port, 0x7E);
      print('Received data: $data');
    } catch (e) {
      print('Error: $e');
    }
  }

  void updatePorts(){
    ports = SerialPort.availablePorts;
    notifyListeners();
  }
}