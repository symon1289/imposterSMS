import 'package:hive/hive.dart';
import 'hive_type_ids.dart';

part 'question.g.dart';

@HiveType(typeId: HiveTypeIds.question)
class Question extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  String crewmateQuestion;

  @HiveField(2)
  String imposterQuestion;

  // Non-persisted field to track if question is played in current session
  bool isPlayed = false;

  Question({
    required this.id,
    required this.crewmateQuestion,
    required this.imposterQuestion,
    this.isPlayed = false,
  });
}
