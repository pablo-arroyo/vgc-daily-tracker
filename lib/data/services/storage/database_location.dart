/// Where the app database lives on this platform: `appDatabaseFactory` and
/// `appDatabasePath()`. Web gets IndexedDB; everything else a file.
library;

export 'database_location_io.dart'
    if (dart.library.js_interop) 'database_location_web.dart';
