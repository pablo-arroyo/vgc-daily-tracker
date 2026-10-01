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

  /// The document at [key] (null while there is none), emitted now and
  /// again after each change to it.
  Stream<Map<String, Object?>?> watch(String store, String key) =>
      stringMapStoreFactory
          .store(store)
          .record(key)
          .onSnapshot(_db)
          .map((record) => record?.value);

  /// Every document in [store], by key (e.g. for a backup).
  Future<Result<Map<String, Map<String, Object?>>>> getAll(String store) async {
    final records = await stringMapStoreFactory.store(store).find(_db);
    return Result.ok({for (final r in records) r.key: r.value});
  }

  /// Every document in [store], emitted now and again after each change.
  Stream<List<Map<String, Object?>>> watchAll(String store) =>
      stringMapStoreFactory
          .store(store)
          .query()
          .onSnapshots(_db)
          .map((records) => [for (final record in records) record.value]);

  Future<Result<void>> put(
    String store,
    String key,
    Map<String, Object?> document,
  ) async {
    await stringMapStoreFactory.store(store).record(key).put(_db, document);
    return const Result.ok(null);
  }

  Future<Result<void>> delete(String store, String key) async {
    await stringMapStoreFactory.store(store).record(key).delete(_db);
    return const Result.ok(null);
  }
}
