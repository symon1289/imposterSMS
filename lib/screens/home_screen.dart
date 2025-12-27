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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/app_logo_home.png',
                  height: 450,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Imposter SMS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 48),
                _buildMenuButton(
                  context,
                  label: 'Start Game',
                  onPressed: () => Navigator.pushNamed(context, '/game'),
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  label: 'Manage Players',
                  onPressed: () => Navigator.pushNamed(context, '/players'),
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  label: 'Manage Questions',
                  onPressed: () => Navigator.pushNamed(context, '/questions'),
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  label: 'Game History',
                  onPressed: () => Navigator.pushNamed(context, '/history'),
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  label: 'Settings',
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        elevation: 0,
      ),
      child: Text(label),
    );
  }
}
