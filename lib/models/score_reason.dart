import 'package:objectbox/objectbox.dart';

@Entity()
class ScoreReason {
  ScoreReason({required this.label, required this.delta, this.id = 0});

  @Id()
  int id;

  final String label;
  final int delta;
}
