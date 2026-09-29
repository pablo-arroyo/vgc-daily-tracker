import 'package:sembast/sembast.dart';

import '../../../utils/result.dart';

/// Current storage schema. Bump it with a migration in [openAppDatabase]
/// (and a test that upgrades a database written at the old version) whenever
/// the stored JSON shape changes incompatibly.
const appSchemaVersion = 1;

/// Opens the app database. The factory picks the backend: a file on mobile
/// and desktop, IndexedDB on web, memory in tests.
Future<Database> openAppDatabase(DatabaseFactory factory, String path) =>
    factory.openDatabase(path, version: appSchemaVersion);

/// Key-value document storage on sembast: each named store holds
/// JSON-compatible maps by string key.
class LocalStorageService {
  LocalStorageService(this._db);

  final Database _db;

  Future<Result<Map<String, Object?>?>> get(String store, String key) async =>
      Result.ok(await stringMapStoreFactory.store(store).record(key).get(_db));

  Future<Result<void>> put(
    String store,
    String key,
    Map<String, Object?> document,
  ) async {
    await stringMapStoreFactory.store(store).record(key).put(_db, document);
    return const Result.ok(null);
  }
}
