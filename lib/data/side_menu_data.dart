import 'package:atletec/model/menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.add, title: 'Novo Evento'),
    MenuModel(icon: Icons.groups, title: 'Atletas'),
    MenuModel(icon: Icons.stadium, title: 'Campos'),
    MenuModel(icon: Icons.history, title: 'Histórico'),
    MenuModel(icon: Icons.settings, title: 'Configurações'),
  ];
}
