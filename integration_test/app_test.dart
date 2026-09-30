import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'journeys/log_game_journey.dart';
import 'journeys/smoke_journey.dart';
import 'journeys/storage_journey.dart';
import 'journeys/teams_journey.dart';

/// The single integration entry point. Desktop test runs relaunch the app
/// for every `*_test.dart` file, and the second launch fails to reconnect
/// on macOS, so each journey is a function in `journeys/`, run here as a
/// group in one app session. Add new journeys here, not as new test files.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('smoke', smokeJourney);
  group('storage', storageJourney);
  group('teams', teamsJourney);
  group('log game', logGameJourney);
}
