import 'package:flutter/material.dart';
import '../services/sms_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final smsService = SmsService();
    await smsService.requestAllPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imposter SMS'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/game'),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Game'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/players'),
                icon: const Icon(Icons.people),
                label: const Text('Manage Players'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/questions'),
                icon: const Icon(Icons.question_answer),
                label: const Text('Manage Questions'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/history'),
                icon: const Icon(Icons.history),
                label: const Text('Game History'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                icon: const Icon(Icons.settings),
                label: const Text('Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
