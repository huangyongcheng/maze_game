# Home to Cisbox

> A cute Flutter maze game — navigate a chibi character from home to the Cisbox office.
> The in-app UI is localized in Vietnamese (all user-facing strings live in `app_strings.dart`).

Built with **Flutter 3.x**, **Riverpod**, **Hive**, and **Clean Architecture**.
Runs on Android, iOS, Web, Windows, macOS, and Linux.

> 📖 New to the game? Read the [player guide](docs/how_to_play.md).

---

## Screenshots

> _TODO: drop screenshots into `docs/screenshots/` and link them here._

```
docs/
└── screenshots/
    ├── home.png
    ├── game_easy.png
    ├── game_with_fog.png
    └── win.png
```

---

## Features

- Three difficulties (Easy 10x10, Medium 15x15, Hard 20x20)
- Fog of war that follows the player — radius shrinks as difficulty rises
- Optional map reveal — costs **+30 seconds** every time you turn it on
- Live timer with best-time persistence per difficulty (Hive)
- D-pad and swipe controls (toggle individually in settings)
- Confetti celebration on win
- Hand-drawn `CustomPainter` art — no image assets required
- Vietnamese UI strings centralized in `app_strings.dart`

---

## How to play

1. **Pick a difficulty** from the home screen (Easy 10×10 / Medium 15×15 / Hard 20×20). Larger grid = smaller visibility radius.
2. **Move** with the D-pad arrows or by swiping the maze. Toggle either control scheme in Settings.
3. **Find the office.** Most of the maze is hidden by fog — only a small radius around the player is visible. Walls block movement; bumping a wall does not cost time.
4. **Reveal the map** with the 👁 button if you're stuck — but every time you turn it ON it adds **+30 seconds** to your total time. No limit on toggles.
5. **Reach the Cisbox office** (bottom-right). The timer stops, a confetti win screen shows your total time, and Hive persists the new best time per difficulty if you beat your previous record.
6. **Pause** any time with the ⏸ button — the timer stops and controls disable until you resume.

**Pro tips:** Try a no-reveal run on Hard. Use the right-hand rule (always turn right at junctions) — it's guaranteed to find the exit in a perfect maze. The generator is recursive backtracking, so corridors tend to be long and winding.

→ Full Vietnamese player guide with FAQ and detailed tips: [`docs/how_to_play.md`](docs/how_to_play.md).

---

## Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

To run on a specific platform:

```bash
flutter run -d chrome      # web
flutter run -d windows     # Windows desktop (needs Visual Studio C++ workload)
flutter run -d macos       # macOS
flutter run -d <device-id> # Android / iOS
```

To build release artifacts:

```bash
flutter build apk --release          # Android
flutter build ios --release          # iOS
flutter build web --release          # Web (output in build/web)
flutter build windows --release      # Windows
flutter build macos --release        # macOS
flutter build linux --release        # Linux
```

---

## Architecture

Clean Architecture, three layers, strict inward-only dependencies.

```
lib/
├── main.dart              Hive init, DI overrides, runApp
├── app.dart               MaterialApp + theme
│
├── core/                  Constants, theme, audio singleton, failures
│
├── domain/                Pure Dart — entities, abstract repos, use cases
│   ├── entities/          Maze, Cell, Position, Direction, Player,
│   │                      Difficulty, GameSession
│   ├── repositories/      MazeRepository, ScoreRepository, AudioRepository
│   └── usecases/          GenerateMaze, MovePlayer, CheckWin,
│                          SaveScore, GetBestTime, RevealMap
│
├── data/                  Concrete implementations
│   ├── datasources/       Hive + audioplayers
│   ├── models/            ScoreModel (Hive-annotated)
│   └── repositories/      MazeRepositoryImpl (recursive backtracking),
│                          ScoreRepositoryImpl, AudioRepositoryImpl
│
└── presentation/
    ├── providers/         Riverpod (game, settings, score)
    ├── screens/           Splash, Home, Game, Win, Settings
    └── widgets/           MazePainter, PlayerPainter, HomeIconPainter,
                           CisboxIconPainter, FogOfWarOverlay,
                           DPadControls, GameHud, PauseOverlay,
                           RevealPenaltyToast
```

### Maze generation

`MazeRepositoryImpl` runs iterative **recursive backtracking** to produce a
_perfect_ maze (a spanning tree of the grid — exactly one path between any
two cells, no loops, no isolated regions).

Invariants are pinned by tests in
[`test/domain/maze_generator_test.dart`](test/domain/maze_generator_test.dart):
- every cell is reachable from `(0,0)`
- edges count == `width * height - 1` (spanning-tree property)
- start is `(0,0)`, end is bottom-right

---

## Replacing the Cisbox logo (placeholder)

The office icon at the maze exit is drawn by `CisboxIconPainter` — a stylized
building shape, **not** the real brand mark. To swap in a real logo:

1. Drop the file at `assets/images/cisbox_logo.png` (square PNG works best).
2. In `pubspec.yaml`, uncomment the `assets:` block and add:
   ```yaml
   flutter:
     assets:
       - assets/images/
   ```
3. In `lib/presentation/screens/game_screen.dart`, replace the
   `CustomPaint(painter: CisboxIconPainter())` with
   `Image.asset('assets/images/cisbox_logo.png')`.

---

## Adding real sound files

Audio is wired through `AudioManager` -> `AudioRepositoryImpl` ->
`AudioPlayersDatasource`. Currently the datasource logs each sound event
instead of playing one (no audio files ship with this scaffold).

To enable real audio:

1. Drop your files into `assets/sounds/`:
   ```
   assets/sounds/
   ├── footstep.wav
   ├── wall_bump.wav
   ├── win.wav
   ├── pause.wav
   └── penalty.wav
   ```
2. In `pubspec.yaml`, uncomment the `assets:` block and add:
   ```yaml
   flutter:
     assets:
       - assets/sounds/
   ```
3. In
   [`lib/data/datasources/audio/audioplayers_datasource.dart`](lib/data/datasources/audio/audioplayers_datasource.dart),
   map each `GameSound` to its asset path inside `_assetForSound`.

The master mute toggle lives on the Settings screen.

---

## Testing

```bash
flutter test
```

Covers:

| File | Concern |
|---|---|
| `test/domain/maze_generator_test.dart` | Perfect-maze invariants (connectivity, spanning-tree edge count, dimensions) |
| `test/domain/move_player_usecase_test.dart` | Wall collisions, grid boundaries, facing updates |
| `test/data/score_repository_test.dart` | Best-time persistence and per-difficulty isolation |
| `test/presentation/d_pad_test.dart` | D-pad tap -> correct direction; disabled state ignores taps |

---

## License

Internal Cisbox project. © 2026 Cisbox.
