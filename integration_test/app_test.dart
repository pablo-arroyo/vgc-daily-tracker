import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'journeys/backup_journey.dart';
import 'journeys/best_of_three_journey.dart';
import 'journeys/log_game_journey.dart';
import 'journeys/opponent_teams_journey.dart';
import 'journeys/sample_teams_journey.dart';
import 'journeys/smoke_journey.dart';
import 'journeys/storage_journey.dart';
import 'journeys/team_import_journey.dart';
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
  group('team import', teamImportJourney);
  group('sample teams', sampleTeamsJourney);
  group('opponent teams', opponentTeamsJourney);
  group('backup', backupJourney);
  group('best-of-3', bestOfThreeJourney);
}
