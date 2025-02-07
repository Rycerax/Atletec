import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/manager.dart';
import '../model/match.dart';

class NewmatchScreen extends StatefulWidget {
  const NewmatchScreen({super.key});

  @override
  _NewmatchScreenState createState() => _NewmatchScreenState();
}

class _NewmatchScreenState extends State<NewmatchScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  final sportsList = ['Futebol', 'Jump System'];
  String? selectedSport;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    selectedSport = '';
  }

  @override
  void dispose() {
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
            SizedBox(
              width: 240,
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
            ),
            SizedBox(
              width: 240,
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
            ),
            DropdownButtonFormField(
              menuMaxHeight: 200,
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
            // DropdownButtonFormField(
            //   decoration: const InputDecoration(
            //     labelText: 'Selecione o Esporte',
            //     border: OutlineInputBorder(),
            //   ),
            //   items: sportsList.map((sport) {
            //     return DropdownMenuItem(
            //       value: sport,
            //       child: Text(sport),
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       selectedSport = value;
            //     });
            //   },
            // ),
            DropdownButtonFormField(
              menuMaxHeight: 200,
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
            Navigator.of(context).pop();  // Cancela e retorna
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isNotEmpty &&
                descriptionController.text.isNotEmpty &&
                manager.selectedField != null &&
                manager.selectedPlayer != null) {
              String dataString = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
              final newMatch = Match(
                id: manager.getNextMatchId(),
                name: nameController.text,
                date: dataString,
                description: descriptionController.text,
                sport: "Futebol",
                playerId: manager.selectedPlayer!.id,
                fieldId: manager.selectedField!.id,
              );
              manager.addMatch(newMatch);
              manager.selectMatch(newMatch);  // Seleciona a partida recém-criada
              manager.updatedIsMatch(true);
              
              Navigator.of(context).pop();  // Retorna para a tela anterior apenas se a partida for salva
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
