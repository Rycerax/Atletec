import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:atletec/const/constant.dart';
import 'package:atletec/provider/manager.dart';
import 'package:atletec/screens/main_screen.dart';
import 'model/player.dart';
import 'model/field.dart';

void main() async {
  // Inicializar Hive e registrar adaptadores
  await Hive.initFlutter();
  Hive.registerAdapter(PlayerAdapter());
  Hive.registerAdapter(FieldAdapter());
  await Hive.openBox<Player>('players');
  await Hive.openBox<Field>('fields');

  runApp(
    ChangeNotifierProvider(
      create: (context) => Manager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atletec',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
