import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/manager.dart';
import '../model/field.dart';

class FieldsScreen extends StatelessWidget {
  const FieldsScreen({super.key});

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
                  onPressed: () {
                    final selectedField = manager.selectedField;
                    if (selectedField != null) {
                      manager.removeField(selectedField.id);
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
              TextField(
                controller: coordinatesController,
                decoration: const InputDecoration(labelText: 'Coordenadas (lat1, long1...)'),
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
              final coordinates = coordinatesController.text;

              if (field == null) {
                final newField = Field(
                  id: manager.getNextFieldId(),
                  name: name,
                  coordinates: coordinates,
                );
                manager.addField(newField);
              } else {
                field.name = name;
                field.coordinates = coordinates;
                manager.updateField(field);
              }

              Navigator.of(context).pop();
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
