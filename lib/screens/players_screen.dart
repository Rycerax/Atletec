import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/manager.dart';
import '../model/player.dart';

class PlayersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<Manager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Jogadores'),
      ),
      body: Row(
        children: [
          // Lista de jogadores
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: ListView.builder(
                itemCount: manager.players.length,
                itemBuilder: (context, index) {
                  final player = manager.players[index];
                  return ListTile(
                    title: Text(player.name),
                    tileColor: manager.selectedPlayer?.id == player.id ? Colors.grey[700] : null,
                    textColor: manager.selectedPlayer?.id == player.id ? Colors.white : null,
                    onTap: () {
                      manager.selectPlayer(player);
                    },
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
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _showPlayerDialog(context, manager, null);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    final selectedPlayer = manager.selectedPlayer;
                    if (selectedPlayer != null) {
                      _showPlayerDialog(context, manager, selectedPlayer);
                    } else {
                      _showMessage(context, 'Selecione um jogador para editar.');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    final selectedPlayer = manager.selectedPlayer;
                    if (selectedPlayer != null) {
                      manager.removePlayer(selectedPlayer.id);
                    } else {
                      _showMessage(context, 'Selecione um jogador para excluir.');
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

  void _showPlayerDialog(BuildContext context, Manager manager, Player? player) {
    final nameController = TextEditingController(text: player?.name ?? '');
    final cpfController = TextEditingController(text: player?.cpf ?? '');
    final sexoController = TextEditingController(text: player?.sexo ?? '');
    final pesoController = TextEditingController(text: player?.peso.toString() ?? '');
    final alturaController = TextEditingController(text: player?.altura.toString() ?? '');
    final sportController = TextEditingController(text: player?.sport ?? '');
    final posicaoController = TextEditingController(text: player?.posicao ?? '');
    final observacaoController = TextEditingController(text: player?.observacao ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(player == null ? 'Adicionar Jogador' : 'Editar Jogador'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: cpfController,
                decoration: const InputDecoration(labelText: 'CPF'),
              ),
              TextField(
                controller: sexoController,
                decoration: const InputDecoration(labelText: 'Sexo'),
              ),
              TextField(
                controller: pesoController,
                decoration: const InputDecoration(labelText: 'Peso'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: alturaController,
                decoration: const InputDecoration(labelText: 'Altura'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: sportController,
                decoration: const InputDecoration(labelText: 'Esporte'),
              ),
              TextField(
                controller: posicaoController,
                decoration: const InputDecoration(labelText: 'Posição'),
              ),
              TextField(
                controller: observacaoController,
                decoration: const InputDecoration(labelText: 'Observação'),
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
              final name = nameController.text;
              final cpf = cpfController.text;
              final sexo = sexoController.text;
              final peso = double.tryParse(pesoController.text) ?? 0.0;
              final altura = double.tryParse(alturaController.text) ?? 0.0;
              final sport = sportController.text;
              final posicao = posicaoController.text;
              final observacao = observacaoController.text;

              if (player == null) {
                final newPlayer = Player(
                  id: manager.getNextPlayerId(),
                  name: name,
                  cpf: cpf,
                  sexo: sexo,
                  peso: peso,
                  altura: altura,
                  sport: sport,
                  posicao: posicao,
                  observacao: observacao,
                );
                manager.addPlayer(newPlayer);
              } else {
                player.name = name;
                player.cpf = cpf;
                player.sexo = sexo;
                player.peso = peso;
                player.altura = altura;
                player.sport = sport;
                player.posicao = posicao;
                player.observacao = observacao;
                manager.updatePlayer(player);
              }

              Navigator.of(context).pop();
            },
            child: Text(player == null ? 'Adicionar' : 'Salvar'),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
