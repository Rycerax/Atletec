import 'package:atletec/widgets/header_widget.dart';
import 'package:atletec/widgets/serial_data_plotter.dart';
import 'package:flutter/material.dart';

class Dashboardwidget extends StatelessWidget {
  const Dashboardwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 13,
        ),
        const HeaderWidget(),
        Container(
          height: 13,
        ),
        const SerialDataPlotter()
      ],
    );   
  }
}