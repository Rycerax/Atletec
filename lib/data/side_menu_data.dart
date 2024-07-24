import 'package:atletec/model/menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.add, title: 'Novo Evento'),
    MenuModel(icon: Icons.groups, title: 'Players'),
    MenuModel(icon: Icons.stadium, title: 'Fields'),
    MenuModel(icon: Icons.history, title: 'History'),
    MenuModel(icon: Icons.settings, title: 'Settings'),
  ];
}
