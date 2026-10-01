// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProgressStats {

 int get totalGames; int? get winRatePercent; int get gamesLast7Days; int? get winRateLast7DaysPercent; int get dayStreak; WeeklyFocus? get weeklyFocus; List<MistakeCount> get mistakeBreakdown; List<TeamRecord> get teamRecords;/// Your record against each saved opponent team (games linked to one).
 List<TeamRecord> get opponentTeamRecords; List<LeadRecord> get opponentLeads;/// Best-of-3 sets: decided ones make the record; ended early or still
/// open ones count as unfinished.
 int get setsWon; int get setsLost; int? get setWinRatePercent; int get unfinishedSets;/// Win % in game 1 of a set, against games 2–3 (how you adapt).
 int? get game1WinRatePercent; int? get laterGamesWinRatePercent;/// The most recent sets, newest first.
 List<SetRecord> get recentSets; List<GameLog> get recentGames;
/// Create a copy of ProgressStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressStatsCopyWith<ProgressStats> get copyWith => _$ProgressStatsCopyWithImpl<ProgressStats>(this as ProgressStats, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProgressStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressStats&&(identical(other.totalGames, _this.totalGames) || other.totalGames == _this.totalGames)&&(identical(other.winRatePercent, _this.winRatePercent) || other.winRatePercent == _this.winRatePercent)&&(identical(other.gamesLast7Days, _this.gamesLast7Days) || other.gamesLast7Days == _this.gamesLast7Days)&&(identical(other.winRateLast7DaysPercent, _this.winRateLast7DaysPercent) || other.winRateLast7DaysPercent == _this.winRateLast7DaysPercent)&&(identical(other.dayStreak, _this.dayStreak) || other.dayStreak == _this.dayStreak)&&(identical(other.weeklyFocus, _this.weeklyFocus) || other.weeklyFocus == _this.weeklyFocus)&&const DeepCollectionEquality().equals(other.mistakeBreakdown, _this.mistakeBreakdown)&&const DeepCollectionEquality().equals(other.teamRecords, _this.teamRecords)&&const DeepCollectionEquality().equals(other.opponentTeamRecords, _this.opponentTeamRecords)&&const DeepCollectionEquality().equals(other.opponentLeads, _this.opponentLeads)&&(identical(other.setsWon, _this.setsWon) || other.setsWon == _this.setsWon)&&(identical(other.setsLost, _this.setsLost) || other.setsLost == _this.setsLost)&&(identical(other.setWinRatePercent, _this.setWinRatePercent) || other.setWinRatePercent == _this.setWinRatePercent)&&(identical(other.unfinishedSets, _this.unfinishedSets) || other.unfinishedSets == _this.unfinishedSets)&&(identical(other.game1WinRatePercent, _this.game1WinRatePercent) || other.game1WinRatePercent == _this.game1WinRatePercent)&&(identical(other.laterGamesWinRatePercent, _this.laterGamesWinRatePercent) || other.laterGamesWinRatePercent == _this.laterGamesWinRatePercent)&&const DeepCollectionEquality().equals(other.recentSets, _this.recentSets)&&const DeepCollectionEquality().equals(other.recentGames, _this.recentGames));
}


@override
int get hashCode {
  final _this = this as ProgressStats;
  return Object.hash(runtimeType,_this.totalGames,_this.winRatePercent,_this.gamesLast7Days,_this.winRateLast7DaysPercent,_this.dayStreak,_this.weeklyFocus,const DeepCollectionEquality().hash(_this.mistakeBreakdown),const DeepCollectionEquality().hash(_this.teamRecords),const DeepCollectionEquality().hash(_this.opponentTeamRecords),const DeepCollectionEquality().hash(_this.opponentLeads),_this.setsWon,_this.setsLost,_this.setWinRatePercent,_this.unfinishedSets,_this.game1WinRatePercent,_this.laterGamesWinRatePercent,const DeepCollectionEquality().hash(_this.recentSets),const DeepCollectionEquality().hash(_this.recentGames));
}

@override
String toString() {
  final _this = this as ProgressStats;
  return 'ProgressStats(totalGames: ${_this.totalGames}, winRatePercent: ${_this.winRatePercent}, gamesLast7Days: ${_this.gamesLast7Days}, winRateLast7DaysPercent: ${_this.winRateLast7DaysPercent}, dayStreak: ${_this.dayStreak}, weeklyFocus: ${_this.weeklyFocus}, mistakeBreakdown: ${_this.mistakeBreakdown}, teamRecords: ${_this.teamRecords}, opponentTeamRecords: ${_this.opponentTeamRecords}, opponentLeads: ${_this.opponentLeads}, setsWon: ${_this.setsWon}, setsLost: ${_this.setsLost}, setWinRatePercent: ${_this.setWinRatePercent}, unfinishedSets: ${_this.unfinishedSets}, game1WinRatePercent: ${_this.game1WinRatePercent}, laterGamesWinRatePercent: ${_this.laterGamesWinRatePercent}, recentSets: ${_this.recentSets}, recentGames: ${_this.recentGames})';
}


}

/// @nodoc
abstract mixin class $ProgressStatsCopyWith<$Res>  {
  factory $ProgressStatsCopyWith(ProgressStats value, $Res Function(ProgressStats) _then) = _$ProgressStatsCopyWithImpl;
@useResult
$Res call({
 int totalGames, int? winRatePercent, int gamesLast7Days, int? winRateLast7DaysPercent, int dayStreak, WeeklyFocus? weeklyFocus, List<MistakeCount> mistakeBreakdown, List<TeamRecord> teamRecords, List<TeamRecord> opponentTeamRecords, List<LeadRecord> opponentLeads, int setsWon, int setsLost, int? setWinRatePercent, int unfinishedSets, int? game1WinRatePercent, int? laterGamesWinRatePercent, List<SetRecord> recentSets, List<GameLog> recentGames
});


$WeeklyFocusCopyWith<$Res>? get weeklyFocus;

}
/// @nodoc
class _$ProgressStatsCopyWithImpl<$Res>
    implements $ProgressStatsCopyWith<$Res> {
  _$ProgressStatsCopyWithImpl(this._self, this._then);

  final ProgressStats _self;
  final $Res Function(ProgressStats) _then;

/// Create a copy of ProgressStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalGames = null,Object? winRatePercent = freezed,Object? gamesLast7Days = null,Object? winRateLast7DaysPercent = freezed,Object? dayStreak = null,Object? weeklyFocus = freezed,Object? mistakeBreakdown = null,Object? teamRecords = null,Object? opponentTeamRecords = null,Object? opponentLeads = null,Object? setsWon = null,Object? setsLost = null,Object? setWinRatePercent = freezed,Object? unfinishedSets = null,Object? game1WinRatePercent = freezed,Object? laterGamesWinRatePercent = freezed,Object? recentSets = null,Object? recentGames = null,}) {
  return _then(ProgressStats(
totalGames: null == totalGames ? _self.totalGames : totalGames // ignore: cast_nullable_to_non_nullable
as int,winRatePercent: freezed == winRatePercent ? _self.winRatePercent : winRatePercent // ignore: cast_nullable_to_non_nullable
as int?,gamesLast7Days: null == gamesLast7Days ? _self.gamesLast7Days : gamesLast7Days // ignore: cast_nullable_to_non_nullable
as int,winRateLast7DaysPercent: freezed == winRateLast7DaysPercent ? _self.winRateLast7DaysPercent : winRateLast7DaysPercent // ignore: cast_nullable_to_non_nullable
as int?,dayStreak: null == dayStreak ? _self.dayStreak : dayStreak // ignore: cast_nullable_to_non_nullable
as int,weeklyFocus: freezed == weeklyFocus ? _self.weeklyFocus : weeklyFocus // ignore: cast_nullable_to_non_nullable
as WeeklyFocus?,mistakeBreakdown: null == mistakeBreakdown ? _self.mistakeBreakdown : mistakeBreakdown // ignore: cast_nullable_to_non_nullable
as List<MistakeCount>,teamRecords: null == teamRecords ? _self.teamRecords : teamRecords // ignore: cast_nullable_to_non_nullable
as List<TeamRecord>,opponentTeamRecords: null == opponentTeamRecords ? _self.opponentTeamRecords : opponentTeamRecords // ignore: cast_nullable_to_non_nullable
as List<TeamRecord>,opponentLeads: null == opponentLeads ? _self.opponentLeads : opponentLeads // ignore: cast_nullable_to_non_nullable
as List<LeadRecord>,setsWon: null == setsWon ? _self.setsWon : setsWon // ignore: cast_nullable_to_non_nullable
as int,setsLost: null == setsLost ? _self.setsLost : setsLost // ignore: cast_nullable_to_non_nullable
as int,setWinRatePercent: freezed == setWinRatePercent ? _self.setWinRatePercent : setWinRatePercent // ignore: cast_nullable_to_non_nullable
as int?,unfinishedSets: null == unfinishedSets ? _self.unfinishedSets : unfinishedSets // ignore: cast_nullable_to_non_nullable
as int,game1WinRatePercent: freezed == game1WinRatePercent ? _self.game1WinRatePercent : game1WinRatePercent // ignore: cast_nullable_to_non_nullable
as int?,laterGamesWinRatePercent: freezed == laterGamesWinRatePercent ? _self.laterGamesWinRatePercent : laterGamesWinRatePercent // ignore: cast_nullable_to_non_nullable
as int?,recentSets: null == recentSets ? _self.recentSets : recentSets // ignore: cast_nullable_to_non_nullable
as List<SetRecord>,recentGames: null == recentGames ? _self.recentGames : recentGames // ignore: cast_nullable_to_non_nullable
as List<GameLog>,
  ));
}
/// Create a copy of ProgressStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklyFocusCopyWith<$Res>? get weeklyFocus {
    if (_self.weeklyFocus == null) {
    return null;
  }

  return $WeeklyFocusCopyWith<$Res>(_self.weeklyFocus!, (value) {
    return _then(_self.copyWith(weeklyFocus: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProgressStats].
extension ProgressStatsPatterns on ProgressStats {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressStats() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressStats value)  $default,){
final _that = this;
switch (_that) {
case _ProgressStats():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressStats value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressStats() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalGames,  int? winRatePercent,  int gamesLast7Days,  int? winRateLast7DaysPercent,  int dayStreak,  WeeklyFocus? weeklyFocus,  List<MistakeCount> mistakeBreakdown,  List<TeamRecord> teamRecords,  List<TeamRecord> opponentTeamRecords,  List<LeadRecord> opponentLeads,  int setsWon,  int setsLost,  int? setWinRatePercent,  int unfinishedSets,  int? game1WinRatePercent,  int? laterGamesWinRatePercent,  List<SetRecord> recentSets,  List<GameLog> recentGames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressStats() when $default != null:
return $default(_that.totalGames,_that.winRatePercent,_that.gamesLast7Days,_that.winRateLast7DaysPercent,_that.dayStreak,_that.weeklyFocus,_that.mistakeBreakdown,_that.teamRecords,_that.opponentTeamRecords,_that.opponentLeads,_that.setsWon,_that.setsLost,_that.setWinRatePercent,_that.unfinishedSets,_that.game1WinRatePercent,_that.laterGamesWinRatePercent,_that.recentSets,_that.recentGames);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalGames,  int? winRatePercent,  int gamesLast7Days,  int? winRateLast7DaysPercent,  int dayStreak,  WeeklyFocus? weeklyFocus,  List<MistakeCount> mistakeBreakdown,  List<TeamRecord> teamRecords,  List<TeamRecord> opponentTeamRecords,  List<LeadRecord> opponentLeads,  int setsWon,  int setsLost,  int? setWinRatePercent,  int unfinishedSets,  int? game1WinRatePercent,  int? laterGamesWinRatePercent,  List<SetRecord> recentSets,  List<GameLog> recentGames)  $default,) {final _that = this;
switch (_that) {
case _ProgressStats():
return $default(_that.totalGames,_that.winRatePercent,_that.gamesLast7Days,_that.winRateLast7DaysPercent,_that.dayStreak,_that.weeklyFocus,_that.mistakeBreakdown,_that.teamRecords,_that.opponentTeamRecords,_that.opponentLeads,_that.setsWon,_that.setsLost,_that.setWinRatePercent,_that.unfinishedSets,_that.game1WinRatePercent,_that.laterGamesWinRatePercent,_that.recentSets,_that.recentGames);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalGames,  int? winRatePercent,  int gamesLast7Days,  int? winRateLast7DaysPercent,  int dayStreak,  WeeklyFocus? weeklyFocus,  List<MistakeCount> mistakeBreakdown,  List<TeamRecord> teamRecords,  List<TeamRecord> opponentTeamRecords,  List<LeadRecord> opponentLeads,  int setsWon,  int setsLost,  int? setWinRatePercent,  int unfinishedSets,  int? game1WinRatePercent,  int? laterGamesWinRatePercent,  List<SetRecord> recentSets,  List<GameLog> recentGames)?  $default,) {final _that = this;
switch (_that) {
case _ProgressStats() when $default != null:
return $default(_that.totalGames,_that.winRatePercent,_that.gamesLast7Days,_that.winRateLast7DaysPercent,_that.dayStreak,_that.weeklyFocus,_that.mistakeBreakdown,_that.teamRecords,_that.opponentTeamRecords,_that.opponentLeads,_that.setsWon,_that.setsLost,_that.setWinRatePercent,_that.unfinishedSets,_that.game1WinRatePercent,_that.laterGamesWinRatePercent,_that.recentSets,_that.recentGames);case _:
  return null;

}
}

}

/// @nodoc


class _ProgressStats implements ProgressStats {
  const _ProgressStats({required this.totalGames, required this.winRatePercent, required this.gamesLast7Days, required this.winRateLast7DaysPercent, required this.dayStreak, required this.weeklyFocus, required  List<MistakeCount> mistakeBreakdown, required  List<TeamRecord> teamRecords, required  List<TeamRecord> opponentTeamRecords, required  List<LeadRecord> opponentLeads, required this.setsWon, required this.setsLost, required this.setWinRatePercent, required this.unfinishedSets, required this.game1WinRatePercent, required this.laterGamesWinRatePercent, required  List<SetRecord> recentSets, required  List<GameLog> recentGames}): _mistakeBreakdown = mistakeBreakdown,_teamRecords = teamRecords,_opponentTeamRecords = opponentTeamRecords,_opponentLeads = opponentLeads,_recentSets = recentSets,_recentGames = recentGames;
  

@override final  int totalGames;
@override final  int? winRatePercent;
@override final  int gamesLast7Days;
@override final  int? winRateLast7DaysPercent;
@override final  int dayStreak;
@override final  WeeklyFocus? weeklyFocus;
 final  List<MistakeCount> _mistakeBreakdown;
@override List<MistakeCount> get mistakeBreakdown {
  if (_mistakeBreakdown is EqualUnmodifiableListView) return _mistakeBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mistakeBreakdown);
}

 final  List<TeamRecord> _teamRecords;
@override List<TeamRecord> get teamRecords {
  if (_teamRecords is EqualUnmodifiableListView) return _teamRecords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teamRecords);
}

/// Your record against each saved opponent team (games linked to one).
 final  List<TeamRecord> _opponentTeamRecords;
/// Your record against each saved opponent team (games linked to one).
@override List<TeamRecord> get opponentTeamRecords {
  if (_opponentTeamRecords is EqualUnmodifiableListView) return _opponentTeamRecords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_opponentTeamRecords);
}

 final  List<LeadRecord> _opponentLeads;
@override List<LeadRecord> get opponentLeads {
  if (_opponentLeads is EqualUnmodifiableListView) return _opponentLeads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_opponentLeads);
}

/// Best-of-3 sets: decided ones make the record; ended early or still
/// open ones count as unfinished.
@override final  int setsWon;
@override final  int setsLost;
@override final  int? setWinRatePercent;
@override final  int unfinishedSets;
/// Win % in game 1 of a set, against games 2–3 (how you adapt).
@override final  int? game1WinRatePercent;
@override final  int? laterGamesWinRatePercent;
/// The most recent sets, newest first.
 final  List<SetRecord> _recentSets;
/// The most recent sets, newest first.
@override List<SetRecord> get recentSets {
  if (_recentSets is EqualUnmodifiableListView) return _recentSets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentSets);
}

 final  List<GameLog> _recentGames;
@override List<GameLog> get recentGames {
  if (_recentGames is EqualUnmodifiableListView) return _recentGames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentGames);
}


/// Create a copy of ProgressStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressStatsCopyWith<_ProgressStats> get copyWith => __$ProgressStatsCopyWithImpl<_ProgressStats>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressStats&&(identical(other.totalGames, totalGames) || other.totalGames == totalGames)&&(identical(other.winRatePercent, winRatePercent) || other.winRatePercent == winRatePercent)&&(identical(other.gamesLast7Days, gamesLast7Days) || other.gamesLast7Days == gamesLast7Days)&&(identical(other.winRateLast7DaysPercent, winRateLast7DaysPercent) || other.winRateLast7DaysPercent == winRateLast7DaysPercent)&&(identical(other.dayStreak, dayStreak) || other.dayStreak == dayStreak)&&(identical(other.weeklyFocus, weeklyFocus) || other.weeklyFocus == weeklyFocus)&&const DeepCollectionEquality().equals(other.mistakeBreakdown, _mistakeBreakdown)&&const DeepCollectionEquality().equals(other.teamRecords, _teamRecords)&&const DeepCollectionEquality().equals(other.opponentTeamRecords, _opponentTeamRecords)&&const DeepCollectionEquality().equals(other.opponentLeads, _opponentLeads)&&(identical(other.setsWon, setsWon) || other.setsWon == setsWon)&&(identical(other.setsLost, setsLost) || other.setsLost == setsLost)&&(identical(other.setWinRatePercent, setWinRatePercent) || other.setWinRatePercent == setWinRatePercent)&&(identical(other.unfinishedSets, unfinishedSets) || other.unfinishedSets == unfinishedSets)&&(identical(other.game1WinRatePercent, game1WinRatePercent) || other.game1WinRatePercent == game1WinRatePercent)&&(identical(other.laterGamesWinRatePercent, laterGamesWinRatePercent) || other.laterGamesWinRatePercent == laterGamesWinRatePercent)&&const DeepCollectionEquality().equals(other.recentSets, _recentSets)&&const DeepCollectionEquality().equals(other.recentGames, _recentGames));
}


@override
int get hashCode {
    return Object.hash(runtimeType,totalGames,winRatePercent,gamesLast7Days,winRateLast7DaysPercent,dayStreak,weeklyFocus,const DeepCollectionEquality().hash(_mistakeBreakdown),const DeepCollectionEquality().hash(_teamRecords),const DeepCollectionEquality().hash(_opponentTeamRecords),const DeepCollectionEquality().hash(_opponentLeads),setsWon,setsLost,setWinRatePercent,unfinishedSets,game1WinRatePercent,laterGamesWinRatePercent,const DeepCollectionEquality().hash(_recentSets),const DeepCollectionEquality().hash(_recentGames));
}

@override
String toString() {
    return 'ProgressStats(totalGames: $totalGames, winRatePercent: $winRatePercent, gamesLast7Days: $gamesLast7Days, winRateLast7DaysPercent: $winRateLast7DaysPercent, dayStreak: $dayStreak, weeklyFocus: $weeklyFocus, mistakeBreakdown: $mistakeBreakdown, teamRecords: $teamRecords, opponentTeamRecords: $opponentTeamRecords, opponentLeads: $opponentLeads, setsWon: $setsWon, setsLost: $setsLost, setWinRatePercent: $setWinRatePercent, unfinishedSets: $unfinishedSets, game1WinRatePercent: $game1WinRatePercent, laterGamesWinRatePercent: $laterGamesWinRatePercent, recentSets: $recentSets, recentGames: $recentGames)';
}


}

/// @nodoc
abstract mixin class _$ProgressStatsCopyWith<$Res> implements $ProgressStatsCopyWith<$Res> {
  factory _$ProgressStatsCopyWith(_ProgressStats value, $Res Function(_ProgressStats) _then) = __$ProgressStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalGames, int? winRatePercent, int gamesLast7Days, int? winRateLast7DaysPercent, int dayStreak, WeeklyFocus? weeklyFocus, List<MistakeCount> mistakeBreakdown, List<TeamRecord> teamRecords, List<TeamRecord> opponentTeamRecords, List<LeadRecord> opponentLeads, int setsWon, int setsLost, int? setWinRatePercent, int unfinishedSets, int? game1WinRatePercent, int? laterGamesWinRatePercent, List<SetRecord> recentSets, List<GameLog> recentGames
});


@override $WeeklyFocusCopyWith<$Res>? get weeklyFocus;

}
/// @nodoc
class __$ProgressStatsCopyWithImpl<$Res>
    implements _$ProgressStatsCopyWith<$Res> {
  __$ProgressStatsCopyWithImpl(this._self, this._then);

  final _ProgressStats _self;
  final $Res Function(_ProgressStats) _then;

/// Create a copy of ProgressStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalGames = null,Object? winRatePercent = freezed,Object? gamesLast7Days = null,Object? winRateLast7DaysPercent = freezed,Object? dayStreak = null,Object? weeklyFocus = freezed,Object? mistakeBreakdown = null,Object? teamRecords = null,Object? opponentTeamRecords = null,Object? opponentLeads = null,Object? setsWon = null,Object? setsLost = null,Object? setWinRatePercent = freezed,Object? unfinishedSets = null,Object? game1WinRatePercent = freezed,Object? laterGamesWinRatePercent = freezed,Object? recentSets = null,Object? recentGames = null,}) {
  return _then(_ProgressStats(
totalGames: null == totalGames ? _self.totalGames : totalGames // ignore: cast_nullable_to_non_nullable
as int,winRatePercent: freezed == winRatePercent ? _self.winRatePercent : winRatePercent // ignore: cast_nullable_to_non_nullable
as int?,gamesLast7Days: null == gamesLast7Days ? _self.gamesLast7Days : gamesLast7Days // ignore: cast_nullable_to_non_nullable
as int,winRateLast7DaysPercent: freezed == winRateLast7DaysPercent ? _self.winRateLast7DaysPercent : winRateLast7DaysPercent // ignore: cast_nullable_to_non_nullable
as int?,dayStreak: null == dayStreak ? _self.dayStreak : dayStreak // ignore: cast_nullable_to_non_nullable
as int,weeklyFocus: freezed == weeklyFocus ? _self.weeklyFocus : weeklyFocus // ignore: cast_nullable_to_non_nullable
as WeeklyFocus?,mistakeBreakdown: null == mistakeBreakdown ? _self._mistakeBreakdown : mistakeBreakdown // ignore: cast_nullable_to_non_nullable
as List<MistakeCount>,teamRecords: null == teamRecords ? _self._teamRecords : teamRecords // ignore: cast_nullable_to_non_nullable
as List<TeamRecord>,opponentTeamRecords: null == opponentTeamRecords ? _self._opponentTeamRecords : opponentTeamRecords // ignore: cast_nullable_to_non_nullable
as List<TeamRecord>,opponentLeads: null == opponentLeads ? _self._opponentLeads : opponentLeads // ignore: cast_nullable_to_non_nullable
as List<LeadRecord>,setsWon: null == setsWon ? _self.setsWon : setsWon // ignore: cast_nullable_to_non_nullable
as int,setsLost: null == setsLost ? _self.setsLost : setsLost // ignore: cast_nullable_to_non_nullable
as int,setWinRatePercent: freezed == setWinRatePercent ? _self.setWinRatePercent : setWinRatePercent // ignore: cast_nullable_to_non_nullable
as int?,unfinishedSets: null == unfinishedSets ? _self.unfinishedSets : unfinishedSets // ignore: cast_nullable_to_non_nullable
as int,game1WinRatePercent: freezed == game1WinRatePercent ? _self.game1WinRatePercent : game1WinRatePercent // ignore: cast_nullable_to_non_nullable
as int?,laterGamesWinRatePercent: freezed == laterGamesWinRatePercent ? _self.laterGamesWinRatePercent : laterGamesWinRatePercent // ignore: cast_nullable_to_non_nullable
as int?,recentSets: null == recentSets ? _self._recentSets : recentSets // ignore: cast_nullable_to_non_nullable
as List<SetRecord>,recentGames: null == recentGames ? _self._recentGames : recentGames // ignore: cast_nullable_to_non_nullable
as List<GameLog>,
  ));
}

/// Create a copy of ProgressStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklyFocusCopyWith<$Res>? get weeklyFocus {
    if (_self.weeklyFocus == null) {
    return null;
  }

  return $WeeklyFocusCopyWith<$Res>(_self.weeklyFocus!, (value) {
    return _then(_self.copyWith(weeklyFocus: value));
  });
}
}

/// @nodoc
mixin _$WeeklyFocus {

 MistakeCategory get mistake; int get count; int get gamesWithMistakes;
/// Create a copy of WeeklyFocus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyFocusCopyWith<WeeklyFocus> get copyWith => _$WeeklyFocusCopyWithImpl<WeeklyFocus>(this as WeeklyFocus, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WeeklyFocus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyFocus&&(identical(other.mistake, _this.mistake) || other.mistake == _this.mistake)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.gamesWithMistakes, _this.gamesWithMistakes) || other.gamesWithMistakes == _this.gamesWithMistakes));
}


@override
int get hashCode {
  final _this = this as WeeklyFocus;
  return Object.hash(runtimeType,_this.mistake,_this.count,_this.gamesWithMistakes);
}

@override
String toString() {
  final _this = this as WeeklyFocus;
  return 'WeeklyFocus(mistake: ${_this.mistake}, count: ${_this.count}, gamesWithMistakes: ${_this.gamesWithMistakes})';
}


}

/// @nodoc
abstract mixin class $WeeklyFocusCopyWith<$Res>  {
  factory $WeeklyFocusCopyWith(WeeklyFocus value, $Res Function(WeeklyFocus) _then) = _$WeeklyFocusCopyWithImpl;
@useResult
$Res call({
 MistakeCategory mistake, int count, int gamesWithMistakes
});




}
/// @nodoc
class _$WeeklyFocusCopyWithImpl<$Res>
    implements $WeeklyFocusCopyWith<$Res> {
  _$WeeklyFocusCopyWithImpl(this._self, this._then);

  final WeeklyFocus _self;
  final $Res Function(WeeklyFocus) _then;

/// Create a copy of WeeklyFocus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mistake = null,Object? count = null,Object? gamesWithMistakes = null,}) {
  return _then(WeeklyFocus(
mistake: null == mistake ? _self.mistake : mistake // ignore: cast_nullable_to_non_nullable
as MistakeCategory,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,gamesWithMistakes: null == gamesWithMistakes ? _self.gamesWithMistakes : gamesWithMistakes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyFocus].
extension WeeklyFocusPatterns on WeeklyFocus {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyFocus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyFocus() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyFocus value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyFocus():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyFocus value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyFocus() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MistakeCategory mistake,  int count,  int gamesWithMistakes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyFocus() when $default != null:
return $default(_that.mistake,_that.count,_that.gamesWithMistakes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MistakeCategory mistake,  int count,  int gamesWithMistakes)  $default,) {final _that = this;
switch (_that) {
case _WeeklyFocus():
return $default(_that.mistake,_that.count,_that.gamesWithMistakes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MistakeCategory mistake,  int count,  int gamesWithMistakes)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyFocus() when $default != null:
return $default(_that.mistake,_that.count,_that.gamesWithMistakes);case _:
  return null;

}
}

}

/// @nodoc


class _WeeklyFocus implements WeeklyFocus {
  const _WeeklyFocus({required this.mistake, required this.count, required this.gamesWithMistakes});
  

@override final  MistakeCategory mistake;
@override final  int count;
@override final  int gamesWithMistakes;

/// Create a copy of WeeklyFocus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyFocusCopyWith<_WeeklyFocus> get copyWith => __$WeeklyFocusCopyWithImpl<_WeeklyFocus>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyFocus&&(identical(other.mistake, mistake) || other.mistake == mistake)&&(identical(other.count, count) || other.count == count)&&(identical(other.gamesWithMistakes, gamesWithMistakes) || other.gamesWithMistakes == gamesWithMistakes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mistake,count,gamesWithMistakes);
}

@override
String toString() {
    return 'WeeklyFocus(mistake: $mistake, count: $count, gamesWithMistakes: $gamesWithMistakes)';
}


}

/// @nodoc
abstract mixin class _$WeeklyFocusCopyWith<$Res> implements $WeeklyFocusCopyWith<$Res> {
  factory _$WeeklyFocusCopyWith(_WeeklyFocus value, $Res Function(_WeeklyFocus) _then) = __$WeeklyFocusCopyWithImpl;
@override @useResult
$Res call({
 MistakeCategory mistake, int count, int gamesWithMistakes
});




}
/// @nodoc
class __$WeeklyFocusCopyWithImpl<$Res>
    implements _$WeeklyFocusCopyWith<$Res> {
  __$WeeklyFocusCopyWithImpl(this._self, this._then);

  final _WeeklyFocus _self;
  final $Res Function(_WeeklyFocus) _then;

/// Create a copy of WeeklyFocus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mistake = null,Object? count = null,Object? gamesWithMistakes = null,}) {
  return _then(_WeeklyFocus(
mistake: null == mistake ? _self.mistake : mistake // ignore: cast_nullable_to_non_nullable
as MistakeCategory,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,gamesWithMistakes: null == gamesWithMistakes ? _self.gamesWithMistakes : gamesWithMistakes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$MistakeCount {

 MistakeCategory get mistake; int get count;
/// Create a copy of MistakeCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MistakeCountCopyWith<MistakeCount> get copyWith => _$MistakeCountCopyWithImpl<MistakeCount>(this as MistakeCount, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MistakeCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MistakeCount&&(identical(other.mistake, _this.mistake) || other.mistake == _this.mistake)&&(identical(other.count, _this.count) || other.count == _this.count));
}


@override
int get hashCode {
  final _this = this as MistakeCount;
  return Object.hash(runtimeType,_this.mistake,_this.count);
}

@override
String toString() {
  final _this = this as MistakeCount;
  return 'MistakeCount(mistake: ${_this.mistake}, count: ${_this.count})';
}


}

/// @nodoc
abstract mixin class $MistakeCountCopyWith<$Res>  {
  factory $MistakeCountCopyWith(MistakeCount value, $Res Function(MistakeCount) _then) = _$MistakeCountCopyWithImpl;
@useResult
$Res call({
 MistakeCategory mistake, int count
});




}
/// @nodoc
class _$MistakeCountCopyWithImpl<$Res>
    implements $MistakeCountCopyWith<$Res> {
  _$MistakeCountCopyWithImpl(this._self, this._then);

  final MistakeCount _self;
  final $Res Function(MistakeCount) _then;

/// Create a copy of MistakeCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mistake = null,Object? count = null,}) {
  return _then(MistakeCount(
mistake: null == mistake ? _self.mistake : mistake // ignore: cast_nullable_to_non_nullable
as MistakeCategory,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MistakeCount].
extension MistakeCountPatterns on MistakeCount {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MistakeCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MistakeCount() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MistakeCount value)  $default,){
final _that = this;
switch (_that) {
case _MistakeCount():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MistakeCount value)?  $default,){
final _that = this;
switch (_that) {
case _MistakeCount() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MistakeCategory mistake,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MistakeCount() when $default != null:
return $default(_that.mistake,_that.count);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MistakeCategory mistake,  int count)  $default,) {final _that = this;
switch (_that) {
case _MistakeCount():
return $default(_that.mistake,_that.count);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MistakeCategory mistake,  int count)?  $default,) {final _that = this;
switch (_that) {
case _MistakeCount() when $default != null:
return $default(_that.mistake,_that.count);case _:
  return null;

}
}

}

/// @nodoc


class _MistakeCount implements MistakeCount {
  const _MistakeCount({required this.mistake, required this.count});
  

@override final  MistakeCategory mistake;
@override final  int count;

/// Create a copy of MistakeCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MistakeCountCopyWith<_MistakeCount> get copyWith => __$MistakeCountCopyWithImpl<_MistakeCount>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MistakeCount&&(identical(other.mistake, mistake) || other.mistake == mistake)&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mistake,count);
}

@override
String toString() {
    return 'MistakeCount(mistake: $mistake, count: $count)';
}


}

/// @nodoc
abstract mixin class _$MistakeCountCopyWith<$Res> implements $MistakeCountCopyWith<$Res> {
  factory _$MistakeCountCopyWith(_MistakeCount value, $Res Function(_MistakeCount) _then) = __$MistakeCountCopyWithImpl;
@override @useResult
$Res call({
 MistakeCategory mistake, int count
});




}
/// @nodoc
class __$MistakeCountCopyWithImpl<$Res>
    implements _$MistakeCountCopyWith<$Res> {
  __$MistakeCountCopyWithImpl(this._self, this._then);

  final _MistakeCount _self;
  final $Res Function(_MistakeCount) _then;

/// Create a copy of MistakeCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mistake = null,Object? count = null,}) {
  return _then(_MistakeCount(
mistake: null == mistake ? _self.mistake : mistake // ignore: cast_nullable_to_non_nullable
as MistakeCategory,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$TeamRecord {

 String get teamId; String get teamName; int get wins; int get losses; int get winRatePercent;
/// Create a copy of TeamRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamRecordCopyWith<TeamRecord> get copyWith => _$TeamRecordCopyWithImpl<TeamRecord>(this as TeamRecord, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TeamRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamRecord&&(identical(other.teamId, _this.teamId) || other.teamId == _this.teamId)&&(identical(other.teamName, _this.teamName) || other.teamName == _this.teamName)&&(identical(other.wins, _this.wins) || other.wins == _this.wins)&&(identical(other.losses, _this.losses) || other.losses == _this.losses)&&(identical(other.winRatePercent, _this.winRatePercent) || other.winRatePercent == _this.winRatePercent));
}


@override
int get hashCode {
  final _this = this as TeamRecord;
  return Object.hash(runtimeType,_this.teamId,_this.teamName,_this.wins,_this.losses,_this.winRatePercent);
}

@override
String toString() {
  final _this = this as TeamRecord;
  return 'TeamRecord(teamId: ${_this.teamId}, teamName: ${_this.teamName}, wins: ${_this.wins}, losses: ${_this.losses}, winRatePercent: ${_this.winRatePercent})';
}


}

/// @nodoc
abstract mixin class $TeamRecordCopyWith<$Res>  {
  factory $TeamRecordCopyWith(TeamRecord value, $Res Function(TeamRecord) _then) = _$TeamRecordCopyWithImpl;
@useResult
$Res call({
 String teamId, String teamName, int wins, int losses, int winRatePercent
});




}
/// @nodoc
class _$TeamRecordCopyWithImpl<$Res>
    implements $TeamRecordCopyWith<$Res> {
  _$TeamRecordCopyWithImpl(this._self, this._then);

  final TeamRecord _self;
  final $Res Function(TeamRecord) _then;

/// Create a copy of TeamRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teamId = null,Object? teamName = null,Object? wins = null,Object? losses = null,Object? winRatePercent = null,}) {
  return _then(TeamRecord(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,losses: null == losses ? _self.losses : losses // ignore: cast_nullable_to_non_nullable
as int,winRatePercent: null == winRatePercent ? _self.winRatePercent : winRatePercent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamRecord].
extension TeamRecordPatterns on TeamRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamRecord value)  $default,){
final _that = this;
switch (_that) {
case _TeamRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamRecord value)?  $default,){
final _that = this;
switch (_that) {
case _TeamRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String teamId,  String teamName,  int wins,  int losses,  int winRatePercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamRecord() when $default != null:
return $default(_that.teamId,_that.teamName,_that.wins,_that.losses,_that.winRatePercent);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String teamId,  String teamName,  int wins,  int losses,  int winRatePercent)  $default,) {final _that = this;
switch (_that) {
case _TeamRecord():
return $default(_that.teamId,_that.teamName,_that.wins,_that.losses,_that.winRatePercent);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String teamId,  String teamName,  int wins,  int losses,  int winRatePercent)?  $default,) {final _that = this;
switch (_that) {
case _TeamRecord() when $default != null:
return $default(_that.teamId,_that.teamName,_that.wins,_that.losses,_that.winRatePercent);case _:
  return null;

}
}

}

/// @nodoc


class _TeamRecord implements TeamRecord {
  const _TeamRecord({required this.teamId, required this.teamName, required this.wins, required this.losses, required this.winRatePercent});
  

@override final  String teamId;
@override final  String teamName;
@override final  int wins;
@override final  int losses;
@override final  int winRatePercent;

/// Create a copy of TeamRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamRecordCopyWith<_TeamRecord> get copyWith => __$TeamRecordCopyWithImpl<_TeamRecord>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamRecord&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.teamName, teamName) || other.teamName == teamName)&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.losses, losses) || other.losses == losses)&&(identical(other.winRatePercent, winRatePercent) || other.winRatePercent == winRatePercent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,teamId,teamName,wins,losses,winRatePercent);
}

@override
String toString() {
    return 'TeamRecord(teamId: $teamId, teamName: $teamName, wins: $wins, losses: $losses, winRatePercent: $winRatePercent)';
}


}

/// @nodoc
abstract mixin class _$TeamRecordCopyWith<$Res> implements $TeamRecordCopyWith<$Res> {
  factory _$TeamRecordCopyWith(_TeamRecord value, $Res Function(_TeamRecord) _then) = __$TeamRecordCopyWithImpl;
@override @useResult
$Res call({
 String teamId, String teamName, int wins, int losses, int winRatePercent
});




}
/// @nodoc
class __$TeamRecordCopyWithImpl<$Res>
    implements _$TeamRecordCopyWith<$Res> {
  __$TeamRecordCopyWithImpl(this._self, this._then);

  final _TeamRecord _self;
  final $Res Function(_TeamRecord) _then;

/// Create a copy of TeamRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teamId = null,Object? teamName = null,Object? wins = null,Object? losses = null,Object? winRatePercent = null,}) {
  return _then(_TeamRecord(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,losses: null == losses ? _self.losses : losses // ignore: cast_nullable_to_non_nullable
as int,winRatePercent: null == winRatePercent ? _self.winRatePercent : winRatePercent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$LeadRecord {

 String get slug; int get timesSeen; int get winRatePercent;
/// Create a copy of LeadRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadRecordCopyWith<LeadRecord> get copyWith => _$LeadRecordCopyWithImpl<LeadRecord>(this as LeadRecord, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LeadRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadRecord&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.timesSeen, _this.timesSeen) || other.timesSeen == _this.timesSeen)&&(identical(other.winRatePercent, _this.winRatePercent) || other.winRatePercent == _this.winRatePercent));
}


@override
int get hashCode {
  final _this = this as LeadRecord;
  return Object.hash(runtimeType,_this.slug,_this.timesSeen,_this.winRatePercent);
}

@override
String toString() {
  final _this = this as LeadRecord;
  return 'LeadRecord(slug: ${_this.slug}, timesSeen: ${_this.timesSeen}, winRatePercent: ${_this.winRatePercent})';
}


}

/// @nodoc
abstract mixin class $LeadRecordCopyWith<$Res>  {
  factory $LeadRecordCopyWith(LeadRecord value, $Res Function(LeadRecord) _then) = _$LeadRecordCopyWithImpl;
@useResult
$Res call({
 String slug, int timesSeen, int winRatePercent
});




}
/// @nodoc
class _$LeadRecordCopyWithImpl<$Res>
    implements $LeadRecordCopyWith<$Res> {
  _$LeadRecordCopyWithImpl(this._self, this._then);

  final LeadRecord _self;
  final $Res Function(LeadRecord) _then;

/// Create a copy of LeadRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slug = null,Object? timesSeen = null,Object? winRatePercent = null,}) {
  return _then(LeadRecord(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,timesSeen: null == timesSeen ? _self.timesSeen : timesSeen // ignore: cast_nullable_to_non_nullable
as int,winRatePercent: null == winRatePercent ? _self.winRatePercent : winRatePercent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LeadRecord].
extension LeadRecordPatterns on LeadRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadRecord value)  $default,){
final _that = this;
switch (_that) {
case _LeadRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadRecord value)?  $default,){
final _that = this;
switch (_that) {
case _LeadRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slug,  int timesSeen,  int winRatePercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadRecord() when $default != null:
return $default(_that.slug,_that.timesSeen,_that.winRatePercent);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slug,  int timesSeen,  int winRatePercent)  $default,) {final _that = this;
switch (_that) {
case _LeadRecord():
return $default(_that.slug,_that.timesSeen,_that.winRatePercent);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slug,  int timesSeen,  int winRatePercent)?  $default,) {final _that = this;
switch (_that) {
case _LeadRecord() when $default != null:
return $default(_that.slug,_that.timesSeen,_that.winRatePercent);case _:
  return null;

}
}

}

/// @nodoc


class _LeadRecord implements LeadRecord {
  const _LeadRecord({required this.slug, required this.timesSeen, required this.winRatePercent});
  

@override final  String slug;
@override final  int timesSeen;
@override final  int winRatePercent;

/// Create a copy of LeadRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadRecordCopyWith<_LeadRecord> get copyWith => __$LeadRecordCopyWithImpl<_LeadRecord>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadRecord&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.timesSeen, timesSeen) || other.timesSeen == timesSeen)&&(identical(other.winRatePercent, winRatePercent) || other.winRatePercent == winRatePercent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,slug,timesSeen,winRatePercent);
}

@override
String toString() {
    return 'LeadRecord(slug: $slug, timesSeen: $timesSeen, winRatePercent: $winRatePercent)';
}


}

/// @nodoc
abstract mixin class _$LeadRecordCopyWith<$Res> implements $LeadRecordCopyWith<$Res> {
  factory _$LeadRecordCopyWith(_LeadRecord value, $Res Function(_LeadRecord) _then) = __$LeadRecordCopyWithImpl;
@override @useResult
$Res call({
 String slug, int timesSeen, int winRatePercent
});




}
/// @nodoc
class __$LeadRecordCopyWithImpl<$Res>
    implements _$LeadRecordCopyWith<$Res> {
  __$LeadRecordCopyWithImpl(this._self, this._then);

  final _LeadRecord _self;
  final $Res Function(_LeadRecord) _then;

/// Create a copy of LeadRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slug = null,Object? timesSeen = null,Object? winRatePercent = null,}) {
  return _then(_LeadRecord(
slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,timesSeen: null == timesSeen ? _self.timesSeen : timesSeen // ignore: cast_nullable_to_non_nullable
as int,winRatePercent: null == winRatePercent ? _self.winRatePercent : winRatePercent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SetRecord {

 String get setId; String get label;
/// Create a copy of SetRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetRecordCopyWith<SetRecord> get copyWith => _$SetRecordCopyWithImpl<SetRecord>(this as SetRecord, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SetRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetRecord&&(identical(other.setId, _this.setId) || other.setId == _this.setId)&&(identical(other.label, _this.label) || other.label == _this.label));
}


@override
int get hashCode {
  final _this = this as SetRecord;
  return Object.hash(runtimeType,_this.setId,_this.label);
}

@override
String toString() {
  final _this = this as SetRecord;
  return 'SetRecord(setId: ${_this.setId}, label: ${_this.label})';
}


}

/// @nodoc
abstract mixin class $SetRecordCopyWith<$Res>  {
  factory $SetRecordCopyWith(SetRecord value, $Res Function(SetRecord) _then) = _$SetRecordCopyWithImpl;
@useResult
$Res call({
 String setId, String label
});




}
/// @nodoc
class _$SetRecordCopyWithImpl<$Res>
    implements $SetRecordCopyWith<$Res> {
  _$SetRecordCopyWithImpl(this._self, this._then);

  final SetRecord _self;
  final $Res Function(SetRecord) _then;

/// Create a copy of SetRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? setId = null,Object? label = null,}) {
  return _then(SetRecord(
setId: null == setId ? _self.setId : setId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SetRecord].
extension SetRecordPatterns on SetRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetRecord value)  $default,){
final _that = this;
switch (_that) {
case _SetRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetRecord value)?  $default,){
final _that = this;
switch (_that) {
case _SetRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String setId,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetRecord() when $default != null:
return $default(_that.setId,_that.label);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String setId,  String label)  $default,) {final _that = this;
switch (_that) {
case _SetRecord():
return $default(_that.setId,_that.label);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String setId,  String label)?  $default,) {final _that = this;
switch (_that) {
case _SetRecord() when $default != null:
return $default(_that.setId,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _SetRecord implements SetRecord {
  const _SetRecord({required this.setId, required this.label});
  

@override final  String setId;
@override final  String label;

/// Create a copy of SetRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetRecordCopyWith<_SetRecord> get copyWith => __$SetRecordCopyWithImpl<_SetRecord>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetRecord&&(identical(other.setId, setId) || other.setId == setId)&&(identical(other.label, label) || other.label == label));
}


@override
int get hashCode {
    return Object.hash(runtimeType,setId,label);
}

@override
String toString() {
    return 'SetRecord(setId: $setId, label: $label)';
}


}

/// @nodoc
abstract mixin class _$SetRecordCopyWith<$Res> implements $SetRecordCopyWith<$Res> {
  factory _$SetRecordCopyWith(_SetRecord value, $Res Function(_SetRecord) _then) = __$SetRecordCopyWithImpl;
@override @useResult
$Res call({
 String setId, String label
});




}
/// @nodoc
class __$SetRecordCopyWithImpl<$Res>
    implements _$SetRecordCopyWith<$Res> {
  __$SetRecordCopyWithImpl(this._self, this._then);

  final _SetRecord _self;
  final $Res Function(_SetRecord) _then;

/// Create a copy of SetRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? setId = null,Object? label = null,}) {
  return _then(_SetRecord(
setId: null == setId ? _self.setId : setId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
