import 'dart:io';

import 'package:atletec/provider/manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:provider/provider.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  String? selectedPort;
  List<String> comPorts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCOMPorts();
  }

  Future<void> fetchCOMPorts() async {
    setState(() {
      comPorts = SerialPort.availablePorts;
      print(comPorts);
    });
  }

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<Manager>(context);
    return AlertDialog(
      title: const Text('Configuração'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton<String>(
              hint: const Text('Selecione a porta COM'),
              value: selectedPort,
              onChanged: (String? newValue){
                setState(() {
                  selectedPort = newValue;
                });
              },
              items: comPorts.map<DropdownMenuItem<String>>((String value){
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            manager.selectPort(selectedPort!);
            Navigator.of(context).pop();
          },
          child: const Text('Confirmar'),
        )
      ],
    );
  }
}