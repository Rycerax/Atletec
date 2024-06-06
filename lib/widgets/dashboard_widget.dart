import 'package:atletec/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class Dashboardwidget extends StatelessWidget {
  const Dashboardwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 18),
        HeaderWidget(),
      ],
    );   
  }
}