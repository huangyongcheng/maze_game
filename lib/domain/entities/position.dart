import 'direction.dart';

/// Immutable grid position. Equality is value-based so positions can be used
/// as map keys.
class Position {
  const Position(this.x, this.y);

  final int x;
  final int y;

  Position translate(Direction direction) {
    final d = direction.delta;
    return Position(x + d.dx, y + d.dy);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Position && other.x == x && other.y == y);

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x, $y)';
}
