import 'package:atletec/provider/manager.dart';
import 'package:atletec/widgets/header_widget.dart';
import 'package:atletec/widgets/serial_data_plotter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboardwidget extends StatelessWidget {
  const Dashboardwidget({super.key});

  @override
  Widget build(BuildContext context) {
    final st = Provider.of<Manager>(context);
    return !st.isMatch
        ? Container(
            color: Colors.white,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Projeto ATLETEC',
                  style: TextStyle(
                      fontSize: 50,
                      color: Color(0xFF15131C),
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 100,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'lib/images/Logo.png',
                  height: 250,
                ),
              ),
            ]),
          )
        : Column(
            children: [
              Container(
                height: 13,
              ),
              const HeaderWidget(),
              Container(
                height: 13,
              ),
              const SerialDataPlotter(),
            ],
          );
  }
}
