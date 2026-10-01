import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../utils/result.dart';
import '../models/backup.dart';

/// Why some text can't be restored as a backup, in words the player can
/// act on.
class BackupFormatException implements Exception {
  const BackupFormatException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Reads and writes backups as JSON text, marked with the app and a format
/// version so other JSON (or a newer app's backup) is refused clearly.
abstract final class BackupFormat {
  static const _app = 'vgc_daily_tracker';

  /// Bump, with a way to read the older shape, if the backup JSON changes
  /// incompatibly.
  static const formatVersion = 1;

  static String encode(Backup backup) => const JsonEncoder.withIndent(
    '  ',
  ).convert({'app': _app, 'format_version': formatVersion, ...backup.toJson()});

  static Result<Backup> decode(String text) {
    final Object? json;
    try {
      json = jsonDecode(text);
    } on FormatException {
      return _refuse("This isn't a backup: it's not JSON.");
    }
    if (json is! Map<String, Object?> || json['app'] != _app) {
      return _refuse("This isn't a VGC Daily Tracker backup.");
    }
    if (json['format_version'] case final int version
        when version > formatVersion) {
      return _refuse(
        'This backup is from a newer version of the app. Update the app to '
        'restore it.',
      );
    }
    try {
      return Result.ok(Backup.fromJson(json));
    } on CheckedFromJsonException {
      return _refuse("This backup is damaged and can't be restored.");
    }
  }

  static Result<Backup> _refuse(String message) =>
      Result.failure(BackupFormatException(message));
}
