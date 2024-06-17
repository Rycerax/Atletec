import 'package:atletec/const/constant.dart';
import 'package:atletec/data/side_menu_data.dart';
import 'package:atletec/provider/manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  int selectedIndex = 0;
  final sports = ['Soccer', 'Jump System', 'Surf'];

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();
    final st = Provider.of<Manager>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 13),
          child: DropdownMenu(
            dropdownMenuEntries: sports
                .map((op) => DropdownMenuEntry(value: op, label: op))
                .toList(),
            expandedInsets: EdgeInsets.zero,
            label: const Text('Select the Sport'),
            onSelected: (value) {
              if (value != null) {
                st.updateSport(value);
              }
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data.menu.length,
            itemBuilder: (context, index) => buildMenuEntry(data, index),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.battery_4_bar),
                    const SizedBox(width: 10),
                    Text('${st.battery == 0 ? '' : '${st.battery}%'}'),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildMenuEntry(SideMenuData data, int index) {
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
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
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
