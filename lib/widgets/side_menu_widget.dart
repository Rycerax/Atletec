import 'package:atletec/const/constant.dart';
import 'package:atletec/data/side_menu_data.dart';
import 'package:flutter/material.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();
    return ListView.builder(
        itemCount: data.menu.length,
        itemBuilder: (context, index) => buildMenuEntry(data, index),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );   
  }

  Widget buildMenuEntry(SideMenuData data, int index){
    final isSelected = selectedIndex == index;
    return Container(
      height: 47,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        color: isSelected ? selectionColor : Colors.transparent,
      ),
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0)
        ),
        onTap: () => setState(() {
          selectedIndex = index;
        }),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              child: Icon(
                data.menu[index].icon,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
            Text(
              data.menu[index].title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}