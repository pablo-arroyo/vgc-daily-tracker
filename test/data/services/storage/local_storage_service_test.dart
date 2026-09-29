import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:vgc_daily_tracker/data/services/storage/local_storage_service.dart';
import 'package:vgc_daily_tracker/utils/result.dart';

import '../../../../testing/storage.dart';

void main() {
  late LocalStorageService storage;

  setUp(() async => storage = await memoryStorage());

  test('stores a document and reads it back; a missing one is null', () async {
    final put = await storage.put('teams', 'team-1', {
      'name': 'Mega Metagross',
      'pokemon': ['kingambit', 'kleavor'],
    });
    final found = await storage.get('teams', 'team-1');
    final missing = await storage.get('teams', 'team-2');

    expect(put, isA<Ok<void>>());
    expect((found as Ok<Map<String, Object?>?>).value, {
      'name': 'Mega Metagross',
      'pokemon': ['kingambit', 'kleavor'],
    });
    expect((missing as Ok<Map<String, Object?>?>).value, isNull);
  });

  test('a new database opens at schema version 1', () async {
    final db = await openAppDatabase(
      databaseFactoryMemory,
      sembastInMemoryDatabasePath,
    );

    expect(db.version, 1);
    expect(appSchemaVersion, 1);
  });
}
