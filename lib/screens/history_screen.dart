import 'package:atletec/provider/manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<Manager>(context);
    print(manager.matches.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Partidas'),
      ),
      body: ListView.builder(
        itemCount: manager.matches.length,
        itemBuilder: (context, index) {
          final match = manager.matches[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(match.name),
              subtitle: Text(match.description),
              trailing: Text(match.date),
              onTap: () {
                // Ação ao clicar no card (ex: exibir detalhes da partida)
                manager.removeMatch(match.id);
              },
            ),
          );
        },
      ),
    );
  }
}
