import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:home_to_cisbox/data/repositories/maze_repository_impl.dart';
import 'package:home_to_cisbox/domain/entities/difficulty.dart';
import 'package:home_to_cisbox/domain/entities/direction.dart';
import 'package:home_to_cisbox/domain/entities/maze.dart';
import 'package:home_to_cisbox/domain/entities/position.dart';

/// BFS that respects walls. Returns the set of cells reachable from [start].
Set<Position> _reachableFrom(Maze maze, Position start) {
  final visited = <Position>{start};
  final queue = <Position>[start];
  while (queue.isNotEmpty) {
    final current = queue.removeAt(0);
    for (final d in Direction.values) {
      if (maze.hasWall(current, d)) continue;
      final next = current.translate(d);
      if (!maze.isInside(next)) continue;
      if (visited.add(next)) queue.add(next);
    }
  }
  return visited;
}

/// Count edges (cells with no wall between them) — perfect maze invariant:
/// edges == width*height - 1.
int _edgeCount(Maze maze) {
  int edges = 0;
  for (int y = 0; y < maze.height; y++) {
    for (int x = 0; x < maze.width; x++) {
      final p = Position(x, y);
      if (!maze.hasWall(p, Direction.east) && x + 1 < maze.width) edges++;
      if (!maze.hasWall(p, Direction.south) && y + 1 < maze.height) edges++;
    }
  }
  return edges;
}

void main() {
  group('MazeRepositoryImpl', () {
    test('produces correct dimensions for each difficulty', () {
      final repo = MazeRepositoryImpl(random: Random(1));
      expect(repo.generate(Difficulty.easy).width, 10);
      expect(repo.generate(Difficulty.medium).width, 15);
      expect(repo.generate(Difficulty.hard).width, 20);
    });

    test('every cell is reachable from start (connectivity)', () {
      final repo = MazeRepositoryImpl(random: Random(42));
      final maze = repo.generate(Difficulty.medium);
      final reachable = _reachableFrom(maze, maze.start);
      expect(reachable.length, maze.width * maze.height);
    });

    test('end is reachable from start', () {
      final repo = MazeRepositoryImpl(random: Random(7));
      final maze = repo.generate(Difficulty.easy);
      final reachable = _reachableFrom(maze, maze.start);
      expect(reachable.contains(maze.end), isTrue);
    });

    test('is a perfect maze: exactly one path between any two cells', () {
      // A perfect maze has exactly N-1 edges for N cells (it's a spanning
      // tree). Combined with full connectivity, this means there is exactly
      // one path between any two cells.
      final repo = MazeRepositoryImpl(random: Random(99));
      for (final difficulty in Difficulty.values) {
        final maze = repo.generate(difficulty);
        final n = maze.width * maze.height;
        expect(_edgeCount(maze), n - 1,
            reason: 'difficulty $difficulty should be a tree');
      }
    });

    test('start is (0,0) and end is bottom-right', () {
      final maze = MazeRepositoryImpl(random: Random(3)).generate(Difficulty.easy);
      expect(maze.start, const Position(0, 0));
      expect(maze.end, Position(maze.width - 1, maze.height - 1));
    });
  });
}
