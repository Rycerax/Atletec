import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/manager.dart';
import '../model/field.dart';

class FieldsScreen extends StatelessWidget {
  const FieldsScreen({super.key});

  bool isValidCoordinates(String coordinates) {
    final parts = coordinates.split(',');
    if (parts.length != 8) {
      return false;
    }
    try {
      for (var part in parts) {
        double.parse(part.trim());
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<Manager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Campos'),
      ),
      body: Row(
        children: [
          // Lista de campos
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: ListView.builder(
                itemCount: manager.fields.length,
                itemBuilder: (context, index) {
                  final field = manager.fields[index];
                  return ListTile(
                    title: Text(field.name),
                    onTap: () {
                      manager.selectField(field);
                    },
                    selected: manager.selectedField?.id == field.id,
                    selectedTileColor: Colors.grey[800],
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
                    _showFieldDialog(context, manager, null);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    final selectedField = manager.selectedField;
                    if (selectedField != null) {
                      _showFieldDialog(context, manager, selectedField);
                    } else {
                      _showMessage(context, 'Selecione um campo para editar.');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final selectedField = manager.selectedField;
                    if (selectedField != null) {
                      final confirmDelete = await _confirmDelete(context);
                      if(confirmDelete){
                        manager.removeField(selectedField.id);
                      }
                    } else {
                      _showMessage(context, 'Selecione um campo para excluir.');
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
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   child: const Text('Cancel'),
            // ),
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
        content: const Text('Você tem certeza que deseja excluir este campo e seus dados?'),
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

  void _showFieldDialog(BuildContext context, Manager manager, Field? field) {
    final nameController = TextEditingController(text: field?.name ?? '');
    final coordinatesController = TextEditingController(text: field?.coordinates ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(field == null ? 'Adicionar Campo' : 'Editar Campo'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              SizedBox(
                width: 250,  // Define a largura fixa para o TextField
                child: TextField(
                  controller: coordinatesController,
                  maxLines: 1,  // Garante que o TextField tenha apenas uma linha
                  decoration: const InputDecoration(
                    hintText: 'lat1, long1, lat2, long2...',
                  ),
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,  // Faz o texto afastar para o lado
                  ),
                ),
              )
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
              final coordinates = coordinatesController.text;

              if (field == null) {
                if(isValidCoordinates(coordinates)){
                  final newField = Field(
                    id: manager.getNextFieldId(),
                    name: name,
                    coordinates: coordinates,
                  );
                  manager.addField(newField);
                  Navigator.of(context).pop();
                } else {
                  _showMessage(context, "As Coordenadas devem seguir o exemplo: lat1, long1, lat2, long2...");
                }
              } else {
                if(isValidCoordinates(coordinates)){
                  field.name = name;
                  field.coordinates = coordinates;
                  manager.updateField(field);
                  Navigator.of(context).pop();
                } else {
                  _showMessage(context, "As Coordenadas devem seguir o exemplo: lat1, long1, lat2, long2...");
                }
              }

              
            },
            child: Text(field == null ? 'Adicionar' : 'Salvar'),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
