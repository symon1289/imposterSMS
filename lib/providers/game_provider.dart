import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import '../models/player.dart';
import '../models/question.dart';
import '../models/game_history.dart';
import '../services/storage_service.dart';
import '../services/sms_service.dart';
import '../services/audio_service.dart';

class GameProvider extends ChangeNotifier {
  final StorageService _storageService;
  final SmsService _smsService;
  final AudioService _audioService;

  List<Player> _players = [];
  List<Question> _questions = [];
  List<GameHistory> _history = [];

  List<Player> get players => _players;
  List<Question> get questions => _questions;
  List<GameHistory> get history => _history;

  // Game State
  bool _isRoundActive = false;
  bool _isRevealed = false;
  int _countdownSeconds = 180; // 3 minutes default
  int _currentTimerSeconds = 0;
  Timer? _timer;

  // Current Round Data
  Player? _imposter;
  Question? _currentQuestion;

  // Track used questions to prevent repetition
  final Set<int> _usedQuestionIds = {};

  // Track SMS sending status for UI
  final Map<String, String> _playerSmsStatus = {};

  bool get isRoundActive => _isRoundActive;
  bool get isRevealed => _isRevealed;
  int get currentTimerSeconds => _currentTimerSeconds;
  Player? get imposter => _imposter;
  Question? get currentQuestion => _currentQuestion;
  int get countdownSeconds => _countdownSeconds;
  Map<String, String> get playerSmsStatus => _playerSmsStatus;

  GameProvider(this._storageService, this._smsService, this._audioService) {
    _loadData();
  }

  void _loadData() {
    _players = _storageService.playersBox.values.toList();
    _questions = _storageService.questionsBox.values.toList();
    _history = _storageService.historyBox.values.toList().reversed.toList();
    notifyListeners();
  }

  // Player Management
  Future<void> addPlayer(String name, String phone) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    final player = Player(id: id, name: name, phone: phone);
    await _storageService.playersBox.add(player);
    _loadData();
  }

  Future<void> deletePlayer(Player player) async {
    await player.delete();
    _loadData();
  }

  Future<void> updatePlayer(Player player, String name, String phone) async {
    player.name = name;
    player.phone = phone;
    await player.save();
    _loadData();
  }

  // Question Management
  Future<void> addQuestion(String crewmateQ, String imposterQ) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    final question = Question(
      id: id,
      crewmateQuestion: crewmateQ,
      imposterQuestion: imposterQ,
    );
    await _storageService.questionsBox.add(question);
    _loadData();
  }

  Future<void> deleteQuestion(Question question) async {
    await question.delete();
    _loadData();
  }

  Future<void> updateQuestion(
    Question question,
    String crewmateQ,
    String imposterQ,
  ) async {
    question.crewmateQuestion = crewmateQ;
    question.imposterQuestion = imposterQ;
    await question.save();
    _loadData();
  }

  // Settings
  void setCountdownDuration(int minutes) {
    _countdownSeconds = minutes * 60;
    notifyListeners();
  }

  // Game Logic
  Future<String?> startRound() async {
    if (_players.length < 4) return "Need at least 4 players";
    if (_questions.isEmpty) return "Need at least 1 question pair";

    // Check if there are any unplayed questions
    List<Question> unplayedQuestions = _questions
        .where((q) => !q.isPlayed)
        .toList();

    // If all questions have been played, check if we should reset
    if (unplayedQuestions.isEmpty) {
      // If there's only one question and it's already played, don't allow starting a new round
      if (_questions.length == 1) {
        return "The only available question has already been played. Please add more questions or reset the game.";
      }

      // If there are multiple questions, reset all to unplayed
      for (var question in _questions) {
        question.isPlayed = false;
      }
      unplayedQuestions = _questions;
    }

    _isRoundActive = true;
    _isRevealed = false;
    _currentTimerSeconds = _countdownSeconds;

    // Select Random Imposter
    final random = Random();
    _imposter = _players[random.nextInt(_players.length)];

    // Select random question from unplayed pool
    _currentQuestion =
        unplayedQuestions[random.nextInt(unplayedQuestions.length)];

    // Mark this question as played
    _currentQuestion!.isPlayed = true;

    // Also track in the set for backward compatibility
    _usedQuestionIds.add(_currentQuestion!.id);

    // Prepare individual messages for each player
    Map<String, String> recipientMessages = {};

    // Add imposter message
    recipientMessages[_imposter!.phone] =
        "Your Question: ${_currentQuestion!.imposterQuestion}";

    // Add crewmate messages
    for (Player player in _players) {
      if (player.id != _imposter!.id) {
        recipientMessages[player.phone] =
            "Your Question: ${_currentQuestion!.crewmateQuestion}";
      }
    }

    // Initialize status map for UI
    _playerSmsStatus.clear();
    for (var player in _players) {
      _playerSmsStatus[player.phone] = 'Pending';
    }
    notifyListeners();

    // Send SMS to all players with their individual questions
    print('Sending SMS to ${recipientMessages.length} players...');
    Map<String, String> results = await _smsService.sendSmsToMultiple(
      recipientMessages: recipientMessages,
      onProgress: (recipient, status) {
        _playerSmsStatus[recipient] = status;
        notifyListeners();
      },
    );

    // Log results and collect error details
    int successCount = 0;
    int failCount = 0;
    List<String> errorDetails = [];

    for (var entry in results.entries) {
      print('SMS to ${entry.key}: ${entry.value}');
      if (entry.value == 'Success') {
        successCount++;
        _playerSmsStatus[entry.key] = 'Sent';
      } else {
        failCount++;
        _playerSmsStatus[entry.key] = 'Failed';
        errorDetails.add('${entry.key}: ${entry.value}');
      }
    }

    print('SMS Results: $successCount sent, $failCount failed');

    _startTimer();
    notifyListeners();

    // Return detailed error message if any SMS failed
    if (failCount > 0) {
      String errorMsg = 'Failed to send SMS to $failCount player(s):\n';
      errorMsg += errorDetails.join('\n');
      return errorMsg;
    }

    return null; // Success
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTimerSeconds > 0) {
        _currentTimerSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _audioService.playBeep();
        reveal();
      }
    });
  }

  void skipTimer() {
    _timer?.cancel();
    _currentTimerSeconds = 0;
    notifyListeners();
    reveal();
  }

  void reveal() {
    if (_isRevealed) return;
    _isRevealed = true;
    _isRoundActive = false;
    _timer?.cancel();
    _saveHistory();
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    if (_imposter == null || _currentQuestion == null) return;

    final historyItem = GameHistory(
      id: DateTime.now().millisecondsSinceEpoch,
      title: "Round ${_history.length + 1}",
      timestamp: DateTime.now(),
      imposterId: _imposter!.id,
      imposterName: _imposter!.name,
      imposterPhone: _imposter!.phone,
      crewmateQuestion: _currentQuestion!.crewmateQuestion,
      imposterQuestion: _currentQuestion!.imposterQuestion,
    );

    await _storageService.historyBox.add(historyItem);
    _loadData();
  }

  void resetGame() {
    _isRoundActive = false;
    _isRevealed = false;
    _imposter = null;
    _currentQuestion = null;
    _timer?.cancel();
    notifyListeners();
  }

  // Reset all questions to unplayed state
  void resetAllQuestions() {
    for (var question in _questions) {
      question.isPlayed = false;
    }
    _usedQuestionIds.clear();
    notifyListeners();
  }

  // Check if a specific question has been played
  bool isQuestionPlayed(Question question) {
    return question.isPlayed;
  }

  // Get count of unplayed questions
  int getUnplayedQuestionsCount() {
    return _questions.where((q) => !q.isPlayed).length;
  }
}
