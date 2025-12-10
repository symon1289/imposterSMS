import 'package:hive/hive.dart';
import 'hive_type_ids.dart';

part 'game_history.g.dart';

@HiveType(typeId: HiveTypeIds.gameHistory)
class GameHistory extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final int imposterId;

  @HiveField(4)
  final String imposterName;

  @HiveField(5)
  final String imposterPhone;

  @HiveField(6)
  final String crewmateQuestion;

  @HiveField(7)
  final String imposterQuestion;

  GameHistory({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.imposterId,
    required this.imposterName,
    required this.imposterPhone,
    required this.crewmateQuestion,
    required this.imposterQuestion,
  });
}
