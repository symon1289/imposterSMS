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
        title: Text(
          question == null ? 'Add Question Pair' : 'Edit Question Pair',
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _crewmateController,
                decoration: const InputDecoration(
                  labelText: 'Crewmate Question',
                ),
                validator: (value) => value!.isEmpty ? 'Enter question' : null,
              ),
              TextFormField(
                controller: _imposterController,
                decoration: const InputDecoration(
                  labelText: 'Imposter Question',
                ),
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
                final provider = Provider.of<GameProvider>(
                  context,
                  listen: false,
                );
                if (question == null) {
                  provider.addQuestion(
                    _crewmateController.text,
                    _imposterController.text,
                  );
                } else {
                  provider.updateQuestion(
                    question,
                    _crewmateController.text,
                    _imposterController.text,
                  );
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

  Widget _buildQuestionList(
    List<Question> questions,
    GameProvider provider, {
    required bool isPlayedList,
  }) {
    if (questions.isEmpty) {
      return Center(
        child: Text(
          isPlayedList
              ? 'No played questions yet.'
              : 'No unplayed questions available.',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            title: Text(
              'C: ${question.crewmateQuestion}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('I: ${question.imposterQuestion}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Toggle Played Status
                Tooltip(
                  message: isPlayedList ? 'Mark as Unplayed' : 'Mark as Played',
                  child: IconButton(
                    icon: Icon(
                      isPlayedList
                          ? Icons.replay_circle_filled
                          : Icons.check_circle_outline,
                      color: isPlayedList ? Colors.orange : Colors.green,
                    ),
                    onPressed: () => provider.toggleQuestionPlayed(question),
                  ),
                ),
                // Edit
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showAddEditDialog(question),
                ),
                // Delete
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, provider, question),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    GameProvider provider,
    Question question,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Question?'),
        content: const Text('Are you sure you want to delete this question?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteQuestion(question);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Questions'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Unplayed', icon: Icon(Icons.pending_actions)),
              Tab(text: 'Played', icon: Icon(Icons.history)),
            ],
          ),
        ),
        body: Consumer<GameProvider>(
          builder: (context, provider, child) {
            final unplayed = provider.questions
                .where((q) => !q.isPlayed)
                .toList();
            final played = provider.questions.where((q) => q.isPlayed).toList();

            return TabBarView(
              children: [
                _buildQuestionList(unplayed, provider, isPlayedList: false),
                _buildQuestionList(played, provider, isPlayedList: true),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddEditDialog(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
