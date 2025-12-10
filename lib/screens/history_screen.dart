import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/game_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game History'),
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          if (provider.history.isEmpty) {
            return const Center(child: Text('No game history yet.'));
          }
          return ListView.builder(
            itemCount: provider.history.length,
            itemBuilder: (context, index) {
              final history = provider.history[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(history.title),
                  subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(history.timestamp)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Imposter: ${history.imposterName} (${history.imposterPhone})',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                          const SizedBox(height: 8),
                          Text('Imposter Question: ${history.imposterQuestion}'),
                          const SizedBox(height: 4),
                          Text('Crewmate Question: ${history.crewmateQuestion}'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
