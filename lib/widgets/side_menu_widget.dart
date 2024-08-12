import 'package:atletec/data/side_menu_data.dart';
import 'package:atletec/screens/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/players_screen.dart';
import '../screens/fields_screen.dart';
import '../screens/newMatch_screen.dart';
import '../provider/manager.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({super.key});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {

  @override
  Widget build(BuildContext context) {
  final data = SideMenuData();
  final manager = Provider.of<Manager>(context);
    return Column(
      children: [
        manager.selectedMatch == null ?
        Expanded(
          child: ListView.builder(
            itemCount: data.menu.length,
            itemBuilder: (context, index) => buildMenuEntry(data, index),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),
        ):
// ---------- ELSE ---------- //  
        Container(
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
          manager.selectMatch(null);
        }),
        child: const Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              child: Icon(
                Icons.arrow_back,
                color: Colors.grey,
              ),
            ),
            Text(
              "Voltar",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    )
        ,
        manager.battery == 0
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
                          Text('${manager.battery}%'),
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
          if(data.menu[index].title == "Atletas"){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PlayersScreen()),
            );
          } else if(data.menu[index].title == "Campos"){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const FieldsScreen()),
            );
          } else if (data.menu[index].title == "Novo Evento"){
            showDialog(context: context, builder: (context) => NewmatchScreen());
          } else if (data.menu[index].title == 'Histórico') {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
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
