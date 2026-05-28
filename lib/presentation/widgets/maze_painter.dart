import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/maze.dart';

/// Draws the maze grid: cream path cells, plum walls, soft drop shadow.
class MazePainter extends CustomPainter {
  MazePainter({required this.maze});

  final Maze maze;

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / maze.width;

    // Background path cells (one big rounded rect under the whole maze).
    final pathPaint = Paint()..color = AppColors.pathColor;
    final shadowPaint = Paint()
      ..color = AppColors.buttonShadow
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
        rect.deflate(2), const Radius.circular(AppDimensions.radiusM));
    canvas.drawRRect(rrect, shadowPaint);
    canvas.drawRRect(rrect, pathPaint);

    final wallPaint = Paint()
      ..color = AppColors.wallColor
      ..strokeWidth = AppDimensions.wallThickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int y = 0; y < maze.height; y++) {
      for (int x = 0; x < maze.width; x++) {
        final cell = maze.cells[y][x];
        final left = x * cellSize;
        final top = y * cellSize;
        final right = left + cellSize;
        final bottom = top + cellSize;

        if (cell.northWall) {
          canvas.drawLine(Offset(left, top), Offset(right, top), wallPaint);
        }
        if (cell.westWall) {
          canvas.drawLine(Offset(left, top), Offset(left, bottom), wallPaint);
        }
        // Only draw the south wall on the bottom row to avoid double-drawing.
        if (cell.southWall && y == maze.height - 1) {
          canvas.drawLine(
              Offset(left, bottom), Offset(right, bottom), wallPaint);
        }
        // Same for east on the rightmost column.
        if (cell.eastWall && x == maze.width - 1) {
          canvas.drawLine(Offset(right, top), Offset(right, bottom), wallPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant MazePainter old) => old.maze != maze;
}
