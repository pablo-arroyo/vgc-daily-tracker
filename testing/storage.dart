import 'package:sembast/sembast_memory.dart';
import 'package:vgc_daily_tracker/data/services/storage/local_storage_service.dart';

/// A [LocalStorageService] on a fresh in-memory database: nothing touches
/// the disk, and every call returns an empty, isolated store.
Future<LocalStorageService> memoryStorage() async => LocalStorageService(
  await openAppDatabase(databaseFactoryMemory, sembastInMemoryDatabasePath),
);
