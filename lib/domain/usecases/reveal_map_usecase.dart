import '../../core/constants/app_dimensions.dart';
import '../entities/game_session.dart';

/// Toggles map reveal. Each time reveal is turned ON, a penalty of
/// AppDimensions.revealPenaltySeconds is added to the session.
class RevealMapUsecase {
  const RevealMapUsecase();

  GameSession call(GameSession session) {
    final bool willReveal = !session.isMapRevealed;
    final Duration newPenalty = willReveal
        ? session.penaltyTime +
            const Duration(seconds: AppDimensions.revealPenaltySeconds)
        : session.penaltyTime;
    final int newCount =
        willReveal ? session.mapRevealCount + 1 : session.mapRevealCount;

    return session.copyWith(
      isMapRevealed: willReveal,
      penaltyTime: newPenalty,
      mapRevealCount: newCount,
    );
  }
}
