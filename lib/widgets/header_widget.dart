import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(right: 5),
            child: const DropdownMenu(
              expandedInsets: EdgeInsets.zero,
              label: Text('Select COM Port'),
              dropdownMenuEntries: [],
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
      ],
    );    
  }
}