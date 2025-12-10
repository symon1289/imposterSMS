import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/question.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _crewmateController = TextEditingController();
  final _imposterController = TextEditingController();

  void _showAddEditDialog([Question? question]) {
    if (question != null) {
      _crewmateController.text = question.crewmateQuestion;
      _imposterController.text = question.imposterQuestion;
    } else {
      _crewmateController.clear();
      _imposterController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(question == null ? 'Add Question Pair' : 'Edit Question Pair'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _crewmateController,
                decoration: const InputDecoration(labelText: 'Crewmate Question'),
                validator: (value) => value!.isEmpty ? 'Enter question' : null,
              ),
              TextFormField(
                controller: _imposterController,
                decoration: const InputDecoration(labelText: 'Imposter Question'),
                validator: (value) => value!.isEmpty ? 'Enter question' : null,
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
                if (question == null) {
                  provider.addQuestion(_crewmateController.text, _imposterController.text);
                } else {
                  provider.updateQuestion(question, _crewmateController.text, _imposterController.text);
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
        title: const Text('Questions'),
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          if (provider.questions.isEmpty) {
            return const Center(child: Text('No questions added yet.'));
          }
          return ListView.builder(
            itemCount: provider.questions.length,
            itemBuilder: (context, index) {
              final question = provider.questions[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('C: ${question.crewmateQuestion}'),
                  subtitle: Text('I: ${question.imposterQuestion}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showAddEditDialog(question),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => provider.deleteQuestion(question),
                      ),
                    ],
                  ),
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
