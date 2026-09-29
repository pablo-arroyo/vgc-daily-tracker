import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

DatabaseFactory get appDatabaseFactory => databaseFactoryIo;

/// A file in the app-support folder (not visible to the user, backed up by
/// the OS where it applies).
Future<String> appDatabasePath({String name = 'vgc_daily_tracker.db'}) async =>
    '${(await getApplicationSupportDirectory()).path}/$name';
