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
  Future<Result<void>> save(String day, Set<String> checked) =>
      _storage.put(_store, day, {'checked': checked.toList()..sort()});
}
