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

  test('watchAll emits every document, then again after each change', () async {
    await storage.put('teams', 'a', {'name': 'A'});
    final emissions = storage.watchAll('teams').take(2).toList();

    await Future<void>.delayed(Duration.zero);
    await storage.put('teams', 'b', {'name': 'B'});

    final [first, second] = await emissions;
    expect(first, [
      {'name': 'A'},
    ]);
    expect(
      second,
      unorderedEquals([
        {'name': 'A'},
        {'name': 'B'},
      ]),
    );
  });

  test('delete removes a document', () async {
    await storage.put('teams', 'a', {'name': 'A'});

    final deleted = await storage.delete('teams', 'a');

    expect(deleted, isA<Ok<void>>());
    expect((await storage.get('teams', 'a') as Ok).value, isNull);
  });
}
