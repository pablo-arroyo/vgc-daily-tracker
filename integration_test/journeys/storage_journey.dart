import 'package:flutter_test/flutter_test.dart';
import 'package:vgc_daily_tracker/data/services/storage/database_location.dart';
import 'package:vgc_daily_tracker/data/services/storage/local_storage_service.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

/// The real platform database (file on desktop) persists documents.
void storageJourney() {
  test('the real platform database persists documents across reopen', () async {
    // A separate file, so the test never touches the user's real data.
    final path = await appDatabasePath(name: 'integration_test.db');
    addTearDown(() => appDatabaseFactory.deleteDatabase(path));

    final firstOpen = await openAppDatabase(appDatabaseFactory, path);
    await LocalStorageService(firstOpen)
        .put('teams', 'team-1', {'name': 'Mega Metagross'});
    await firstOpen.close();

    final secondOpen = await openAppDatabase(appDatabaseFactory, path);
    final stored = await LocalStorageService(secondOpen).get('teams', 'team-1');
    await secondOpen.close();

    expect(secondOpen.version, appSchemaVersion);
    expect((stored as Ok<Map<String, Object?>?>).value, {
      'name': 'Mega Metagross',
    });
  });
}
