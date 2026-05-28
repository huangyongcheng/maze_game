import '../entities/game_session.dart';

class CheckWinUsecase {
  const CheckWinUsecase();

  bool call(GameSession session) =>
      session.player.position == session.maze.end;
}
