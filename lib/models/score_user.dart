import 'package:objectbox/objectbox.dart';

@Entity()
class ScoreUser {
  @Id()
  int id;
   String name;
   int score;
  ScoreUser({
    required this.name,
    this.id = 0,
    this.score = 0,
  });
}
