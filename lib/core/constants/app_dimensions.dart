/// Centralized magic numbers for paddings, radii, durations.
class AppDimensions {
  const AppDimensions._();

  // Spacing
  static const double paddingXS = 4;
  static const double paddingS = 8;
  static const double paddingM = 16;
  static const double paddingL = 24;
  static const double paddingXL = 32;

  // Radii
  static const double radiusS = 8;
  static const double radiusM = 16;
  static const double radiusL = 24;

  // Maze
  static const double wallThickness = 3.0;

  // Animations (ms)
  static const int playerMoveMs = 150;
  static const int splashMs = 2000;
  static const int fogToggleMs = 300;

  // Penalty
  static const int revealPenaltySeconds = 30;

  // Timer tick
  static const int timerTickMs = 100;
}
