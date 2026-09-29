import 'package:sembast_web/sembast_web.dart';

DatabaseFactory get appDatabaseFactory => databaseFactoryWeb;

/// On web the "path" is just the IndexedDB database name.
Future<String> appDatabasePath({String name = 'vgc_daily_tracker.db'}) async =>
    name;
