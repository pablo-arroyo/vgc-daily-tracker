import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

import '../../../data/repositories/routine/routine_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/iso_date.dart';
import '../../../utils/result.dart';

/// State for the Routine tab: which checklist items are ticked today. Ticks
/// are saved per local day, so the checklist starts fresh every day.
class RoutineViewModel extends ChangeNotifier {
  RoutineViewModel({
    required this._routineRepository,
    DateTime Function(DateTime utc)? toLocal,
  }) : _toLocal = toLocal ?? ((utc) => utc.toLocal()) {
    toggle = Command1(_toggle);
    _day = isoDate(_toLocal(clock.now().toUtc()));
    _load();
  }

  final RoutineRepository _routineRepository;
  final DateTime Function(DateTime utc) _toLocal;

  /// Ticks or unticks an item, then saves; a failed save puts it back.
  late final Command1<void, String> toggle;

  bool _loaded = false;
  Set<String> _checked = {};

  bool get loaded => _loaded;

  bool isChecked(String itemId) => _checked.contains(itemId);

  /// The local date loaded, which ticks are saved under. Fixed at load, so
  /// ticks made after midnight with the tab still open go to the day on
  /// screen; the next load starts the new day.
  late final String _day;

  Future<void> _load() async {
    final result = await _routineRepository.checkedOn(_day);
    if (result case Ok(:final value)) _checked = value;
    _loaded = true;
    notifyListeners();
  }

  Future<Result<void>> _toggle(String itemId) async {
    final before = _checked;
    _checked = before.contains(itemId)
        ? ({...before}..remove(itemId))
        : {...before, itemId};
    notifyListeners(); // tick at once, save in the background
    final saved = await _routineRepository.save(_day, _checked);
    if (saved is Failure) {
      _checked = before;
      notifyListeners();
    }
    return saved;
  }
}
