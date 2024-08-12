import 'package:atletec/widgets/dashboard_widget.dart';
import 'package:atletec/widgets/side_menu_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    
    return const Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                child: SideMenuWidget(),
              ),
            ),
            Expanded(
              flex: 8,
              child: Dashboardwidget(),
            ),
          ],
        ),
      ),
    );
  }
}