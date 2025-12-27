import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _showStatusDialog(BuildContext context, GameProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Consumer<GameProvider>(
          builder: (context, provider, child) {
            bool allFinished = provider.playerSmsStatus.values.every(
              (status) => status == 'Sent' || status.startsWith('Failed'),
            );

            // Determine if we should show close button (only when all finished)
            // Implicitly, if map is empty, we are just starting
            if (provider.playerSmsStatus.isEmpty) allFinished = false;

            int failCount = provider.playerSmsStatus.values
                .where((s) => s.startsWith('Failed'))
                .length;

            return AlertDialog(
              title: Text(
                allFinished ? 'SMS Sending Complete' : 'Sending SMS...',
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...provider.players.map((player) {
                        String status =
                            provider.playerSmsStatus[player.phone] ?? 'Pending';
                        Color color = Colors.grey;
                        IconData icon = Icons.circle_outlined;

                        if (status == 'Sent') {
                          color = Colors.green;
                          icon = Icons.check_circle;
                        } else if (status.startsWith('Failed')) {
                          color = Colors.red;
                          icon = Icons.error;
                        } else if (status == 'Sending...' ||
                            status == 'Retrying...') {
                          color = Colors.blue;
                          icon = Icons.hourglass_empty;
                        }

                        // Check if actively loading
                        bool isLoading =
                            status == 'Sending...' || status == 'Retrying...';

                        return ListTile(
                          leading: Icon(icon, color: color),
                          title: Text(player.name),
                          subtitle: Text(status),
                          trailing: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : null,
                        );
                      }),
                      if (failCount > 0 && allFinished)
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Some messages failed. Check your balance or network.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                if (allFinished)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(failCount > 0 ? 'Close' : 'Start Game'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          if (!provider.isRoundActive && !provider.isRevealed) {
            // Start Screen
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ready to start?',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    // Display question status
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Unplayed Questions: ${provider.getUnplayedQuestionsCount()} / ${provider.questions.length}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (provider.getUnplayedQuestionsCount() == 0 &&
                                provider.questions.isNotEmpty)
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'All questions have been played!',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Start Button with validation logic
                    ElevatedButton(
                      onPressed:
                          (provider.players.length >= 4 &&
                              provider.questions.isNotEmpty)
                          ? () {
                              _showStatusDialog(context, provider);
                              provider.startRound().then((error) {});
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                      ),
                      child: const Text(
                        'Start Round',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    if (!(provider.players.length >= 4 &&
                        provider.questions.isNotEmpty))
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          children: [
                            if (provider.players.length < 4)
                              Text(
                                'Need at least 4 players (Currently: ${provider.players.length})',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (provider.questions.isEmpty)
                              const Text(
                                'Need at least 1 question pair',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    // Add reset questions button if all questions are played
                    if (provider.getUnplayedQuestionsCount() == 0 &&
                        provider.questions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: OutlinedButton(
                          onPressed: () {
                            provider.resetAllQuestions();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'All questions reset to unplayed',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                          ),
                          child: const Text(
                            'Reset All Questions',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          } else if (provider.isRoundActive) {
            // Timer Screen
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Round in Progress',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Display Crewmate Question
                    Card(
                      color: Colors.blue.shade50,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Text(
                              'Crewmate Question',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              provider.currentQuestion?.crewmateQuestion ?? '',
                              style: const TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      _formatTime(provider.currentTimerSeconds),
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: provider.skipTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Skip Countdown & Reveal',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Reveal Screen
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Round Over!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'The Imposter was:',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    provider.imposter?.name ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    provider.imposter?.phone ?? '',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Imposter Question',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.currentQuestion?.imposterQuestion ?? '',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Crewmate Question',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.currentQuestion?.crewmateQuestion ?? '',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: provider.resetGame,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Start New Round'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
