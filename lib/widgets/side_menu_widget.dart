import 'package:atletec/data/side_menu_data.dart';
import 'package:atletec/provider/manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/players_screen.dart';
import '../screens/fields_screen.dart';
import '../screens/newMatch_screen.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  final sports = ['Soccer', 'Jump System', 'Surf'];

  @override
  Widget build(BuildContext context) {
    final data = SideMenuData();
    final st = Provider.of<Manager>(context);
    final dropMenuController = TextEditingController(text: st.sport);
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
            controller: dropMenuController,
            onSelected: (value) {
              if (value != null) {
                showDialog(context: context, builder: (context) => NewmatchScreen(selectedSport: value));
              }
            }
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data.menu.length,
            itemBuilder: (context, index) => buildMenuEntry(data, index),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),
        ),
        st.battery == 0
            ? const SizedBox()
            : Expanded(
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
                          Text('${st.battery}%'),
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
    return Container(
      height: 47,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        color: Colors.transparent,
      ),
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        onTap: () => setState(() {
          print(data.menu[index].title);
          if(data.menu[index].title == "Players"){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PlayersScreen()),
            );
          } else if(data.menu[index].title == "Fields"){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => FieldsScreen()),
            );
          }
        }),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              child: Icon(
                data.menu[index].icon,
                color: Colors.grey,
              ),
            ),
            Text(
              data.menu[index].title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
