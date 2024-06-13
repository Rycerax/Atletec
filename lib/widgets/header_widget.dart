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
    final st = Provider.of<Manager>(context);
    return Row(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(right: 5),
            child: DropdownMenu<dynamic>(
              onSelected: (value) {
                st.selectPort(value);
              },
              expandedInsets: EdgeInsets.zero,
              label: const Text('Select COM Port'),
              dropdownMenuEntries: st.ports.map((String port) {
                return DropdownMenuEntry<dynamic>(
                  value: port,
                  label: port,
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: const DropdownMenu(
              expandedInsets: EdgeInsets.zero,
              label: Text('Select Field'),
              dropdownMenuEntries: [],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 5, right: 10),
            child: const DropdownMenu(
              expandedInsets: EdgeInsets.zero,
              label: Text('Select Player'),
              dropdownMenuEntries: [],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {
              st.updatePorts();
            },
            icon: const Icon(Icons.refresh),
            iconSize: 33,
          ),
        ),
      ],
    );    
  }
}