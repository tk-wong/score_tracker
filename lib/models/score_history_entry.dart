import 'package:objectbox/objectbox.dart';

@Entity()
class ScoreHistoryEntry {
   ScoreHistoryEntry({
    required this.userName,
    required this.delta,
    required this.reason,
    required this.timestamp,
    this.id= 0,
  });

  @Id()
   int id;

  final String userName;
  final int delta;
  final String reason;
  @Property(type: PropertyType.dateUtc)
  final DateTime timestamp;
}
