import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu(
          dropdownMenuEntries: [],
        ),
        DropdownMenu(
          dropdownMenuEntries: [],
        ),
        DropdownMenu(
          dropdownMenuEntries: [],
        )
      ],
    );    
  }
}