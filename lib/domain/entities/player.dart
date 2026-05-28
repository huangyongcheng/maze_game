import 'direction.dart';
import 'position.dart';

/// Player state: where they are and which way they last faced.
class Player {
  const Player({
    required this.position,
    this.facing = Direction.east,
  });

  final Position position;
  final Direction facing;

  Player copyWith({Position? position, Direction? facing}) => Player(
        position: position ?? this.position,
        facing: facing ?? this.facing,
      );
}
