import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:atletec/provider/manager.dart';
import 'package:atletec/model/match.dart';
import 'package:path_provider/path_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<Manager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Partidas'),
      ),
      body: Row(
        children: [
          // Lista de Partidas
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: ListView.builder(
                itemCount: manager.matches.length,
                itemBuilder: (context, index) {
                  final match = manager.matches[index];
                  return ListTile(
                    title: Text(match.name),
                    subtitle: Text(match.description),
                    trailing: Text(match.date),
                    onTap: () {
                      manager.selectMatch(match);
                    },
                    selected: manager.selectedMatch?.id == match.id,
                    selectedTileColor: Colors.grey.shade800,
                  );
                },
              ),
            ),
          ),
          // Botões de ação
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () async {
                    final selectedMatch = manager.selectedMatch;
                    if (selectedMatch != null) {
                      try {
                        final directory = await getApplicationDocumentsDirectory();
                        final filePath = '${directory.path}/AtletecData/dados${selectedMatch.id}.csv';
                        if (await File(filePath).exists()) {
                          final result = await OpenFile.open(filePath);

                          if (result.type != ResultType.done) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Não foi possível abrir o arquivo: ${result.message}')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Arquivo CSV não encontrado.')),
                          );
                        }
                      } catch (e) {
                        print("Erro ao tentar abrir o arquivo: $e");
                      }
                    } else {
                      _showMessage(context, 'Selecione uma partida para visualizar.');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    final selectedMatch = manager.selectedMatch;
                    if (selectedMatch != null) {
                      _showMatchDialog(context, manager, selectedMatch);
                    } else {
                      _showMessage(context, 'Selecione uma partida para editar.');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final selectedMatch = manager.selectedMatch;
                    if (selectedMatch != null) {
                      final confirmDelete = await _confirmDelete(context);
                      if (confirmDelete) {
                        await _deleteMatchFile(selectedMatch);
                        manager.removeMatch(selectedMatch.id);
                      }
                    } else {
                      _showMessage(context, 'Selecione uma partida para excluir.');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Você tem certeza que deseja excluir esta partida e seus dados?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  Future<void> _deleteMatchFile(Match match) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/AtletecData/dados${match.id}.csv';
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        print("Arquivo deletado: $filePath");
      } else {
        print("Arquivo não encontrado para exclusão: $filePath");
      }
    } catch (e) {
      print("Erro ao tentar excluir o arquivo: $e");
    }
  }

  void _showMatchDialog(BuildContext context, Manager manager, Match match) {
    final nameController = TextEditingController(text: match.name);
    final descriptionController = TextEditingController(text: match.description);
    final dateController = TextEditingController(text: match.date);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Partida'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Data'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              match.name = nameController.text;
              match.description = descriptionController.text;
              match.date = dateController.text;
              manager.updateMatch(match);
              Navigator.of(context).pop();
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
