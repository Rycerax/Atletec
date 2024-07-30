import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/manager.dart';
import '../model/match.dart';

class NewmatchScreen extends StatefulWidget {
  @override
  _NewmatchScreenState createState() => _NewmatchScreenState();
}

class _NewmatchScreenState extends State<NewmatchScreen> {
  late TextEditingController dateController;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  final sportsList = ['Futebol', 'Jump System'];
  String? selectedSport;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    selectedSport = '';
  }

  @override
  void dispose() {
    dateController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<Manager>(context);

    return AlertDialog(
      title: const Text('Nova Partida'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 16), // Espaçamento entre os widgets
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Data'),
            ),
            const SizedBox(height: 16), // Espaçamento entre os widgets
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 16), // Espaçamento entre os widgets
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Selecione o Campo',
                border: OutlineInputBorder(),
              ),
              items: manager.fields.map((field) {
                return DropdownMenuItem(
                  value: field,
                  child: Text(field.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  manager.selectField(value!);
                });
              },
            ),
            const SizedBox(height: 16), // Espaçamento entre os widgets
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Selecione o Esporte',
                border: OutlineInputBorder(),
              ),
              items: sportsList.map((sport) {
                return DropdownMenuItem(
                  value: sport,
                  child: Text(sport),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSport = value;
                });
              },
            ),
            const SizedBox(height: 16), // Espaçamento entre os widgets
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Selecione o Atleta',
                border: OutlineInputBorder(),
              ),
              items: manager.players.map((player) {
                return DropdownMenuItem(
                  value: player,
                  child: Text(player.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  manager.selectPlayer(value!);
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            manager.updateSport('');
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty &&
                dateController.text.isNotEmpty &&
                descriptionController.text.isNotEmpty &&
                selectedSport != "" &&
                manager.selectedField != null &&
                manager.selectedPlayer != null) {
                
              final newMatch = Match(
                id: manager.getNextMatchId(),
                name: nameController.text,
                date: dateController.text,
                sport: selectedSport!,
                description: descriptionController.text,
                player: manager.selectedPlayer!,
                field: manager.selectedField!,
              );
              manager.addMatch(newMatch);
              manager.updateSport(selectedSport!);
              manager.selectMatch(newMatch);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Por favor, preencha todos os campos.')),
              );
            }
          },
          child: const Text('Criar Nova Partida'),
        ),
      ],
    );
  }
}
