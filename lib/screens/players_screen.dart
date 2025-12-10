import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/player.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  void _showAddEditDialog([Player? player]) {
    if (player != null) {
      _nameController.text = player.name;
      _phoneController.text = player.phone;
    } else {
      _nameController.clear();
      _phoneController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(player == null ? 'Add Player' : 'Edit Player'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Enter phone' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final provider = Provider.of<GameProvider>(context, listen: false);
                if (player == null) {
                  provider.addPlayer(_nameController.text, _phoneController.text);
                } else {
                  provider.updatePlayer(player, _nameController.text, _phoneController.text);
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Players'),
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          if (provider.players.isEmpty) {
            return const Center(child: Text('No players added yet.'));
          }
          return ListView.builder(
            itemCount: provider.players.length,
            itemBuilder: (context, index) {
              final player = provider.players[index];
              return ListTile(
                title: Text(player.name),
                subtitle: Text(player.phone),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showAddEditDialog(player),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => provider.deletePlayer(player),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
