import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

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