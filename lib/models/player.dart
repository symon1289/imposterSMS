import 'package:hive/hive.dart';
import 'hive_type_ids.dart';

part 'player.g.dart';

@HiveType(typeId: HiveTypeIds.player)
class Player extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phone;

  Player({
    required this.id,
    required this.name,
    required this.phone,
  });
}
