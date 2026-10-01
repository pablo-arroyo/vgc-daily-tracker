import '../../../utils/result.dart';
import '../../services/storage/local_storage_service.dart';
import 'routine_repository.dart';

/// [RoutineRepository] on local storage: one small document per day.
class RoutineRepositoryLocal implements RoutineRepository {
  RoutineRepositoryLocal({required this._storage});

  final LocalStorageService _storage;

  static const _store = 'routine';

  @override
  Future<Result<Set<String>>> checkedOn(String day) async {
    final result = await _storage.get(_store, day);
    return switch (result) {
      Ok(value: final document) => Result.ok({
        ...?(document?['checked'] as List<Object?>?)?.cast<String>(),
      }),
      Failure(:final error) => Result.failure(error),
    };
  }

  @override
  Stream<Set<String>> watchOn(String day) => _storage
      .watch(_store, day)
      .map(
        (document) => {
          ...?(document?['checked'] as List<Object?>?)?.cast<String>(),
        },
      );

  @override
  Future<Result<Map<String, Set<String>>>> allDays() async {
    final result = await _storage.getAll(_store);
    return switch (result) {
      Ok(value: final documents) => Result.ok({
        for (final MapEntry(key: day, value: document) in documents.entries)
          day: {...(document['checked']! as List<Object?>).cast<String>()},
      }),
      Failure(:final error) => Result.failure(error),
    };
  }

  @override
  Future<Result<void>> save(String day, Set<String> checked) =>
      _storage.put(_store, day, {'checked': checked.toList()..sort()});
}
