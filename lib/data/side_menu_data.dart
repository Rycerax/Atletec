import 'package:atletec/model/menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.play_arrow, title: 'New Game'),
    MenuModel(icon: Icons.groups, title: 'Players'),
    MenuModel(icon: Icons.stadium, title: 'Fields'),
    MenuModel(icon: Icons.history, title: 'History'),
  ];
}