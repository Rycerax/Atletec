import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:atletec/provider/manager.dart';
import 'package:atletec/model/metricModel.dart';
import 'package:atletec/widgets/header_widget.dart';
import 'package:atletec/widgets/metricsScreen.dart';
import 'package:csv/csv.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:atletec/provider/data_processor.dart';

class SerialDataPlotter extends StatefulWidget {
  const SerialDataPlotter({super.key});
  @override
  State<SerialDataPlotter> createState() => _SerialDataPlotterState();
}

class _SerialDataPlotterState extends State<SerialDataPlotter> {
  
  SerialPort? port;
  String imgUrl = 'lib/images/heatmap.png';
  final config = SerialPortConfig();
  int initIndex = 14;
  double yRange = 8000;
  List<int> buffer = [];
  String func = 'Metrics';
  SerialPortReader? reader;
  bool playing = false;
  StreamSubscription<List<int>>? subscription;
  Stream<List<int>>? broadcastStream;
  final _accelxPoints = <FlSpot>[];
  final _accelyPoints = <FlSpot>[];
  final _accelzPoints = <FlSpot>[];
  Timer? _timer;
  int _counter = 0;
  int fileCounter = 0;
  File? imgFile;
  Image? previewImage;
  int imgKey = 0;
  int _secondsElapsed = 0;
  bool _isRunning = false;
  String filePath = '';
  File file = File('');
  ValueNotifier<int> imgKeyNotifier = ValueNotifier(0); // Gerencia atualizações de imagem
  DataPacket pacote_atual = DataPacket(timestamp: DateTime.now(), xg: 0, yg: 0, zg: 0, xa: 0, ya: 0, za: 0, latitude: 0, longitude: 0);
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        imageCache.clear();
        imageCache.clearLiveImages();
        imgKey ^= 1;
      });
    });
    imgFile = File('./lib/images/heatmap.png');
    previewImage = Image.file(imgFile!);
    setState(() {
      imageCache.clear();
      imageCache.clearLiveImages();
    });
    resetData();
    getAppDirect();
  }

  String formatTime(int seconds){
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<String> getAppDirect() async{
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/AtletecData';
    final dir = Directory(path);
    if(!await dir.exists()){
      await dir.create(recursive: true);
    }
    filePath = path;
    file = await File('$filePath/dados${Provider.of<Manager>(context, listen: false).selectedMatch!.id}.csv').create();
    writeData(['time', 'xg', 'yg', 'zg', 'xa', 'ya', 'za', 'lat', 'long']);
    return path;
  }

  void writeData(List<dynamic> data) {
    List<List<dynamic>> rows = [data];
    String csvData = const ListToCsvConverter().convert(rows);
    file.writeAsString('\n$csvData', mode: FileMode.append, flush: true);
  }

  void resetData() async {
    for (var i = 0; i < 500; ++i) {
      setState(() {
        _accelxPoints.add(FlSpot(_counter.toDouble(), 0.0));
        if (_accelxPoints.length > 500) _accelxPoints.removeAt(0);
        _accelyPoints.add(FlSpot(_counter.toDouble(), 0.0));
        if (_accelyPoints.length > 500) _accelyPoints.removeAt(0);
        _accelzPoints.add(FlSpot(_counter.toDouble(), 0.0));
        if (_accelzPoints.length > 500) _accelzPoints.removeAt(0);
        _counter++;
      });
    }
  }

  void _initPort(BuildContext context) {
    port = SerialPort(Provider.of<Manager>(context, listen: false).port!);
    if (port!.openReadWrite()) {
      config.baudRate = 115200;
      config.bits = 8;
      port!.config = config;
      reader = SerialPortReader(port!);
      broadcastStream = reader!.stream.asBroadcastStream();
      _startListening(context);
    } else {
      print('Failed to open port!');
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

  Future<void> setNewCoordinates() async {
    String newCoordinates = Provider.of<Manager>(context, listen: false).selectedField!.coordinates;
    final url = Uri.parse('http://127.0.0.1:5000/atualizar_coordenadas');

    final response = await http.post(url, headers: {'Content-Type': "application/json"}, body: jsonEncode({'coordenadas': newCoordinates}));
    if(response.statusCode == 200){
      print("Coordenadas atualizadas com sucesso");
    } else {
      print("Falha ao configurar as novas coordenadas");
    } 
  }

  void _saveCoordinates(double lat, double long) async {
    final res = await http.post(
      Uri.parse('http://127.0.0.1:5000/execute'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'data': '$func $lat $long',
      }),
    );

    if (res.statusCode == 200) {
      setState(() {
        // imageCache.clear();
        // imageCache.clearLiveImages();
        // imgKey ^= 1;
        imgFile = File('./lib/images/heatmap.png');
      });
      imgKeyNotifier.value++; // Incrementa o valor para atualizar a imagem
    }
  }

  double _bytesToDouble(Uint8List bytes) {
    ByteData byteData = ByteData.sublistView(bytes);
    return byteData.getFloat64(0, Endian.big);
  }

  void _stopListening() {
    _timer?.cancel();
    subscription?.cancel();
    subscription = null;
    resetData();

    if (port != null && port!.isOpen) {
      port!.close();
      print('Serial port closed!');
    }
  }

  void _startListening(BuildContext context) async {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _secondsElapsed++;
      });
    });

    if (broadcastStream == null) {
      print('Broadcast Stream is null!');
      return;
    }

    setNewCoordinates();
    subscription = reader!.stream.listen(
      (data) {
        for (var byte in data) {
          buffer.add(byte);
          if (byte == 0x7e) {
            buffer = _parseData(buffer);
            if (buffer.isEmpty) continue;
            if (buffer.elementAt(1) == 3) {
              Provider.of<Manager>(context, listen: false)
                  .updateBattery(buffer.elementAt(8));
            } else if (buffer.elementAt(1) == 1) {
              double xg = 0.0, yg = 0.0, zg = 0.0, xa = 0.0, ya = 0.0, za = 0.0;
              while (_accelxPoints.length > 500) {
                _accelxPoints.removeAt(0);
                _accelyPoints.removeAt(0);
                _accelzPoints.removeAt(0);
              }
              for (var i = 8; i < buffer.length - 4; i += 12) {
                xg += bytesToInt(buffer.elementAt(i), buffer.elementAt(i + 1)).toDouble();
                yg += bytesToInt(buffer.elementAt(i + 2), buffer.elementAt(i + 3)).toDouble();
                zg += bytesToInt(buffer.elementAt(i + 4), buffer.elementAt(i + 5)).toDouble();
                xa += bytesToInt(buffer.elementAt(i + 6), buffer.elementAt(i + 7)).toDouble();
                ya += bytesToInt(buffer.elementAt(i + 8), buffer.elementAt(i + 9)).toDouble();
                za += bytesToInt(buffer.elementAt(i + 10), buffer.elementAt(i + 11)).toDouble();
              }
              xg /= 20.0;
              yg /= 20.0;
              zg /= 20.0;
              xa /= 20.0;
              ya /= 20.0;
              za /= 20.0;
              pacote_atual.timestamp = DateTime.now();
              pacote_atual.xa = xa;
              pacote_atual.ya = ya;
              pacote_atual.za = za;
              pacote_atual.xg = xg;
              pacote_atual.yg = yg;
              pacote_atual.zg = zg;
              pacote_atual.latitude = 0;
              pacote_atual.longitude = 0;
              
              writeData([DateTime.now(), xg, yg, zg, xa, ya, za, 'ND', 'ND']);
              for (var i = initIndex; i < buffer.length - 4; i += 12) {
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
                      bytesToInt(
                              buffer.elementAt(i + 4), buffer.elementAt(i + 5))
                          .toDouble()));
                  _counter++;
                });
              }
            } else if (buffer.elementAt(1) == 2) {
              Provider.of<Manager>(context, listen: false).updateGPS(true);
              Uint8List newData = Uint8List.fromList(buffer);
              Uint8List latBytes = newData.sublist(8, 16);
              Uint8List longBytes = newData.sublist(16, 24);
              pacote_atual.timestamp = DateTime.now();
              pacote_atual.xa = 0;
              pacote_atual.ya = 0;
              pacote_atual.za = 0;
              pacote_atual.xg = 0;
              pacote_atual.yg = 0;
              pacote_atual.zg = 0;
              pacote_atual.latitude = _bytesToDouble(latBytes);
              pacote_atual.longitude = _bytesToDouble(longBytes);
              writeData([DateTime.now(), 'ND', 'ND', 'ND', 'ND', 'ND', 'ND', _bytesToDouble(latBytes), _bytesToDouble(longBytes)]);
              _saveCoordinates(_bytesToDouble(latBytes), _bytesToDouble(longBytes));
              print(_bytesToDouble(latBytes));
              print(_bytesToDouble(longBytes));
            }
            buffer = [];
          }
        }
      },
      onError: (error) {
        print('Error: $error');
        _stopListening();
      },
      onDone: () {
        print('Stream closed!');
        _stopListening();
      },
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    reader!.close();
    _stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final st = Provider.of<Manager>(context);
    try {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            HeaderWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RadioMenuButton(
                    value: 'Metrics',
                    groupValue: func,
                    onChanged: (val) {
                      st.updateFunc(val!);
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
                    child: const Text('Metrics')),
                st.selectedMatch!.sport == 'Futebol'
                    ? RadioMenuButton(
                        value: 'Heat',
                        groupValue: func,
                        onChanged: (val) {
                          setState(() {
                            st.updateFunc(val!);
                            func = val.toString();
                          });
                        },
                        style: ButtonStyle(
                            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                            elevation: const WidgetStatePropertyAll(5)),
                        child: const Text('Heat Map'))
                    : const SizedBox(),
              ],
            ),
            Expanded(
              child: st.func != 'Heat'
              ? const MetricsScreen()
              : Center(
                  child: imgFile == null
                    ? const Placeholder()
                    : AspectRatio(
                        aspectRatio: 2, // Adjust this aspect ratio to match your image's ratio
                        child: FittedBox(
                          fit: BoxFit.contain, // You can also use BoxFit.cover, BoxFit.fill, etc.
                          child: Image.file(imgFile!, key: ValueKey(imgKey)),
                        ),
                      ),
                ),
            ), 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 35,
                  icon: playing
                      ? const Icon(Icons.stop_circle_rounded)
                      : const Icon(Icons.play_circle_filled_rounded),
                  onPressed: () {
                    if (playing) {
                      _stopListening();
                    } else {
                      _initPort(context);
                    }
                    setState(() {
                      playing = !playing;
                    });
                  },
                ),
                const SizedBox(width: 20),
                Text(formatTime(_secondsElapsed), style: const TextStyle(fontSize: 24, color: Colors.white))
              ]
            )
          ],
        ),
      );
    } catch (e) {
      print(e);
      return const Placeholder();
    }
  }
}
