import 'dart:async';
import 'package:atletec/provider/manager.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class SerialDataPlotter extends StatefulWidget {
  const SerialDataPlotter({super.key});
  @override
  State<SerialDataPlotter> createState() => _SerialDataPlotterState();
}

class _SerialDataPlotterState extends State<SerialDataPlotter> {
  // final SerialService _serialService = SerialService();
  final port = SerialPort('COM4');
  int initIndex = 14;
  double yRange = 8000;
  String func = 'Accel';
  SerialPortReader? reader;
  final _accelxPoints = <FlSpot>[];
  final _accelyPoints = <FlSpot>[];
  final _accelzPoints = <FlSpot>[];
  Timer? _timer;
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 10; ++i) {
      setState(() {
        _accelxPoints.add(FlSpot(_counter.toDouble(), 0.0));
        _accelyPoints.add(FlSpot(_counter.toDouble(), 0.0));
        _accelzPoints.add(FlSpot(_counter.toDouble(), 0.0));
        _counter++;
      });
    }
    _initPort();
  }

  void _initPort() {
    try {
      port.openRead();
      port.config = SerialPortConfig()
        ..baudRate = 115200
        ..bits = 8
        ..stopBits = 1
        ..parity = SerialPortParity.none
        ..setFlowControl(SerialPortFlowControl.none);
      setState(() {
        reader = SerialPortReader(port);
      });
    } catch (error) {
      print(error);
    }
  }

  List<int> _parseData(List<int> buff) {
    List<int> res = [];
    for (var i = 0; i < buff.length - 1; i++) {
      if (buff.elementAt(i) == 0x7d && buff.elementAt(i + 1) == 0x5e) {
        res.add(0x7e);
        i++;
      } else if (buff.elementAt(i) == 0x7d && buff.elementAt(i + 1) == 0x5d) {
        res.add(0x7d);
        i++;
      } else {
        res.add(buff.elementAt(i));
      }
    }
    return res;
  }

  int bytesToInt(int byte1, int byte2) {
    int val = (byte1 << 8) | byte2;

    if (val > 0x7FFF) {
      val -= 0x10000;
    }
    return val;
  }

  void _startFetchingData(BuildContext context) {
    List<int> buffer = [];
    List<int> test = [];
    reader!.stream.listen((data) {
      for (var byte in data) {
        buffer.add(byte);
        if (byte == 0x7e) {
          buffer = _parseData(buffer);
          if (buffer.length < 1) continue;
          print(buffer.elementAt(1));
          if (buffer.elementAt(1) == 3) {
            print('Ok');
            Provider.of<Manager>(context, listen: false)
                .updateBattery(buffer.elementAt(8));
            buffer = [];
            print('Ok');
          } else if (buffer.elementAt(1) == 1) {
            print("Length: ${buffer.length}");
            print(buffer);
            while (_accelxPoints.length > 125) {
              _accelxPoints.removeAt(0);
              _accelyPoints.removeAt(0);
              _accelzPoints.removeAt(0);
            }
            for (var i = initIndex; i < buffer.length - 4; i += 12) {
              test.add(
                  bytesToInt(buffer.elementAt(i), buffer.elementAt(i + 1)));
              setState(() {
                _accelxPoints.add(FlSpot(
                    _counter.toDouble(),
                    bytesToInt(buffer.elementAt(i), buffer.elementAt(i + 1))
                        .toDouble()));
                _accelyPoints.add(FlSpot(
                    _counter.toDouble(),
                    bytesToInt(buffer.elementAt(i + 2), buffer.elementAt(i + 3))
                        .toDouble()));
                _accelzPoints.add(FlSpot(
                    _counter.toDouble(),
                    bytesToInt(buffer.elementAt(i + 4), buffer.elementAt(i + 5))
                        .toDouble()));
                _counter++;
              });
            }
            print('ok');
            print(test);
            // buffer = _parseData(buffer);
            // print('Received: $buffer');
            test = [];
            buffer = [];
          } else if (buffer.elementAt(1) == 2) {
            print('GEO: $buffer');
          }
        }
      }
    });
    // _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
    //   final response = await http.get(Uri.parse('http://127.0.0.1:5000/data'));
    //   if(response.statusCode == 200){
    //     final data = jsonDecode(response.body);
    //     print(data);
    //     if(data['accelz'] != null){
    //       // for(final int d in data['accelz']){
    //       //   setState(() {
    //       //     _accelzPoints.add(FlSpot(_counter.toDouble(), d.toDouble()));
    //       //   });
    //       //   _counter++;
    //       // }
    //       // while(_accelzPoints.length > 100){
    //       //   _accelzPoints.removeAt(0);
    //       // }
    //     }
    //   }
    // });
    // const duration = Duration(milliseconds: 50);
    // _timer = Timer.periodic(duration, (Timer timer) async {
    //   final response = await http.get(Uri.parse('http://127.0.0.1:5000/data?port=$_port'));
    //   if(response.statusCode == 200){
    //     final data = jsonDecode(response.body);
    //     print(data);
    //     if(data['gyroz'] != null){
    //       print(data['gyroz']);
    //     }
    //   }
    // });
    // final responde = await http.get(Uri.parse('http://127.0.0.1:5000/data?port=$_port'));
    // if(responde.statusCode == 200){
    //   final data = jsonDecode(responde.body);
    //   // print(data);
    //   if(data['gyroz'] != null){
    //     print(data['gyroz']);
    //   }
    // }
  }

  @override
  void dispose() {
    _timer?.cancel();
    port.close();
    reader!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final st = Provider.of<Manager>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RadioMenuButton(
                value: 'Accel',
                groupValue: func,
                onChanged: (val) {
                  setState(() {
                    func = val.toString();
                    initIndex = 14;
                    yRange = 8000;
                  });
                },
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    elevation: const WidgetStatePropertyAll(5)),
                child: const Text('Accelerometer')),
            RadioMenuButton(
                value: 'Gyro',
                groupValue: func,
                onChanged: (val) {
                  setState(() {
                    func = val.toString();
                    initIndex = 8;
                    yRange = 32000;
                  });
                },
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    elevation: const WidgetStatePropertyAll(5)),
                child: const Text('Gyroscope')),
            RadioMenuButton(
                value: 'Heat',
                groupValue: func,
                onChanged: (val) {
                  setState(() {
                    func = val.toString();
                  });
                },
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    elevation: const WidgetStatePropertyAll(5)),
                child: const Text('Heat Map')),
          ],
        ),
        AspectRatio(
            aspectRatio: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: LineChart(
                LineChartData(
                  minY: -yRange,
                  maxY: yRange,
                  minX: _accelzPoints.first.x,
                  maxX: _accelzPoints.last.x,
                  lineTouchData: const LineTouchData(enabled: false),
                  clipData: const FlClipData.all(),
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                        spots: _accelxPoints,
                        isCurved: true,
                        barWidth: 2,
                        color: Colors.red,
                        belowBarData: BarAreaData(show: false),
                        dotData: const FlDotData(show: false)),
                    LineChartBarData(
                        spots: _accelyPoints,
                        isCurved: true,
                        barWidth: 2,
                        color: Colors.green,
                        belowBarData: BarAreaData(show: false),
                        dotData: const FlDotData(show: false)),
                    LineChartBarData(
                        spots: _accelzPoints,
                        isCurved: true,
                        barWidth: 2,
                        color: Colors.blue,
                        belowBarData: BarAreaData(show: false),
                        dotData: const FlDotData(show: false))
                  ],
                  titlesData: const FlTitlesData(
                    show: true,
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 40),
                    ),
                  ),
                ),
              ),
            )),
        Center(
          child: IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              _startFetchingData(context);
            },
          ),
        )
      ],
    );
  }
}
