import 'package:atletec/provider/manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Manager>(context, listen: false).updatePorts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<Manager>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(right: 5, left: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Game Description',
                prefixIcon: Icon(Icons.sports_score),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        manager.sport == 'Soccer'
            ? Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Select Field',
                      border: OutlineInputBorder(),
                    ),
                    items: manager.fields.map((field) {
                      return DropdownMenuItem(
                        value: field,
                        child: Text(field.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        manager.selectField(value);
                      }
                    },
                  ),
                ),
              )
            : const SizedBox(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 5, right: 10),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Select Player',
                border: OutlineInputBorder(),
              ),
              items: manager.players.map((player) {
                return DropdownMenuItem(
                  value: player,
                  child: Text(player.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  manager.selectPlayer(value);
                }
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {
              manager.updatePorts();
            },
            icon: const Icon(Icons.refresh),
            iconSize: 33,
          ),
        ),
      ],
    );
  }
}
