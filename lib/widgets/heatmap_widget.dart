import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:latlong2/latlong.dart';

class HeatmapWidget extends StatefulWidget {
  const HeatmapWidget({super.key});

  @override
  State<HeatmapWidget> createState() => _HeatmapWidgetState();
}

class _HeatmapWidgetState extends State<HeatmapWidget> {
  List<WeightedLatLng> data = [];
  @override
  Widget build(BuildContext context) {
    try{
      return Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(-3.7448, -38.5779),
              initialZoom: 8,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
            ],
          ),
        ],
      );
    } catch (e) {
      print(e);
      return const Placeholder();
    }
  }
}