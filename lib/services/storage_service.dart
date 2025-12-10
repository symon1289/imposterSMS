import 'package:hive_flutter/hive_flutter.dart';
import '../models/player.dart';
import '../models/question.dart';
import '../models/game_history.dart';

class StorageService {
  static const String playersBoxName = 'players';
  static const String questionsBoxName = 'questions';
  static const String historyBoxName = 'history';

  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(PlayerAdapter());
    Hive.registerAdapter(QuestionAdapter());
    Hive.registerAdapter(GameHistoryAdapter());

    await Hive.openBox<Player>(playersBoxName);
    await Hive.openBox<Question>(questionsBoxName);
    await Hive.openBox<GameHistory>(historyBoxName);
  }

  Box<Player> get playersBox => Hive.box<Player>(playersBoxName);
  Box<Question> get questionsBox => Hive.box<Question>(questionsBoxName);
  Box<GameHistory> get historyBox => Hive.box<GameHistory>(historyBoxName);
}
