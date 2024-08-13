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
    final selectedMatch = manager.selectedMatch;

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
              initialValue: selectedMatch?.description ?? '',
              readOnly: true,
            ),
          ),
        ),
        manager.sport == 'Futebol'
            ? Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Selected Field',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: manager.getFieldbyId(selectedMatch!.fieldId).name,
                    readOnly: true,
                  ),
                ),
              )
            : const SizedBox(),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 5, right: 10),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Selected Player',
                border: OutlineInputBorder(),
              ),
              initialValue: manager.getPlayerbyId(selectedMatch!.playerId).name,
              readOnly: true,
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
