// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameLog {

 String get id; DateTime get playedAt; GameResult get result; String? get teamId; String? get teamName;/// The full six of the team used; empty when no saved team was picked.
 List<String> get team; List<String> get brought; List<String> get leads;/// The saved opponent team this game was against, if one was picked.
/// Its name is kept too, so a deleted team still reads well.
 String? get opponentTeamId; String? get opponentTeamName; List<String> get opponentTeam; List<String> get opponentBrought; List<String> get opponentLeads;/// "What decided this game?", when answered.
 MistakeCategory? get mistake; String get notes;
/// Create a copy of GameLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameLogCopyWith<GameLog> get copyWith => _$GameLogCopyWithImpl<GameLog>(this as GameLog, _$identity);

  /// Serializes this GameLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GameLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameLog&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.playedAt, _this.playedAt) || other.playedAt == _this.playedAt)&&(identical(other.result, _this.result) || other.result == _this.result)&&(identical(other.teamId, _this.teamId) || other.teamId == _this.teamId)&&(identical(other.teamName, _this.teamName) || other.teamName == _this.teamName)&&const DeepCollectionEquality().equals(other.team, _this.team)&&const DeepCollectionEquality().equals(other.brought, _this.brought)&&const DeepCollectionEquality().equals(other.leads, _this.leads)&&(identical(other.opponentTeamId, _this.opponentTeamId) || other.opponentTeamId == _this.opponentTeamId)&&(identical(other.opponentTeamName, _this.opponentTeamName) || other.opponentTeamName == _this.opponentTeamName)&&const DeepCollectionEquality().equals(other.opponentTeam, _this.opponentTeam)&&const DeepCollectionEquality().equals(other.opponentBrought, _this.opponentBrought)&&const DeepCollectionEquality().equals(other.opponentLeads, _this.opponentLeads)&&(identical(other.mistake, _this.mistake) || other.mistake == _this.mistake)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GameLog;
  return Object.hash(runtimeType,_this.id,_this.playedAt,_this.result,_this.teamId,_this.teamName,const DeepCollectionEquality().hash(_this.team),const DeepCollectionEquality().hash(_this.brought),const DeepCollectionEquality().hash(_this.leads),_this.opponentTeamId,_this.opponentTeamName,const DeepCollectionEquality().hash(_this.opponentTeam),const DeepCollectionEquality().hash(_this.opponentBrought),const DeepCollectionEquality().hash(_this.opponentLeads),_this.mistake,_this.notes);
}

@override
String toString() {
  final _this = this as GameLog;
  return 'GameLog(id: ${_this.id}, playedAt: ${_this.playedAt}, result: ${_this.result}, teamId: ${_this.teamId}, teamName: ${_this.teamName}, team: ${_this.team}, brought: ${_this.brought}, leads: ${_this.leads}, opponentTeamId: ${_this.opponentTeamId}, opponentTeamName: ${_this.opponentTeamName}, opponentTeam: ${_this.opponentTeam}, opponentBrought: ${_this.opponentBrought}, opponentLeads: ${_this.opponentLeads}, mistake: ${_this.mistake}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $GameLogCopyWith<$Res>  {
  factory $GameLogCopyWith(GameLog value, $Res Function(GameLog) _then) = _$GameLogCopyWithImpl;
@useResult
$Res call({
 String id, DateTime playedAt, GameResult result, String? teamId, String? teamName, List<String> team, List<String> brought, List<String> leads, String? opponentTeamId, String? opponentTeamName, List<String> opponentTeam, List<String> opponentBrought, List<String> opponentLeads, MistakeCategory? mistake, String notes
});




}
/// @nodoc
class _$GameLogCopyWithImpl<$Res>
    implements $GameLogCopyWith<$Res> {
  _$GameLogCopyWithImpl(this._self, this._then);

  final GameLog _self;
  final $Res Function(GameLog) _then;

/// Create a copy of GameLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? playedAt = null,Object? result = null,Object? teamId = freezed,Object? teamName = freezed,Object? team = null,Object? brought = null,Object? leads = null,Object? opponentTeamId = freezed,Object? opponentTeamName = freezed,Object? opponentTeam = null,Object? opponentBrought = null,Object? opponentLeads = null,Object? mistake = freezed,Object? notes = null,}) {
  return _then(GameLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as GameResult,teamId: freezed == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String?,teamName: freezed == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String?,team: null == team ? _self.team : team // ignore: cast_nullable_to_non_nullable
as List<String>,brought: null == brought ? _self.brought : brought // ignore: cast_nullable_to_non_nullable
as List<String>,leads: null == leads ? _self.leads : leads // ignore: cast_nullable_to_non_nullable
as List<String>,opponentTeamId: freezed == opponentTeamId ? _self.opponentTeamId : opponentTeamId // ignore: cast_nullable_to_non_nullable
as String?,opponentTeamName: freezed == opponentTeamName ? _self.opponentTeamName : opponentTeamName // ignore: cast_nullable_to_non_nullable
as String?,opponentTeam: null == opponentTeam ? _self.opponentTeam : opponentTeam // ignore: cast_nullable_to_non_nullable
as List<String>,opponentBrought: null == opponentBrought ? _self.opponentBrought : opponentBrought // ignore: cast_nullable_to_non_nullable
as List<String>,opponentLeads: null == opponentLeads ? _self.opponentLeads : opponentLeads // ignore: cast_nullable_to_non_nullable
as List<String>,mistake: freezed == mistake ? _self.mistake : mistake // ignore: cast_nullable_to_non_nullable
as MistakeCategory?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GameLog].
extension GameLogPatterns on GameLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameLog value)  $default,){
final _that = this;
switch (_that) {
case _GameLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameLog value)?  $default,){
final _that = this;
switch (_that) {
case _GameLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime playedAt,  GameResult result,  String? teamId,  String? teamName,  List<String> team,  List<String> brought,  List<String> leads,  String? opponentTeamId,  String? opponentTeamName,  List<String> opponentTeam,  List<String> opponentBrought,  List<String> opponentLeads,  MistakeCategory? mistake,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameLog() when $default != null:
return $default(_that.id,_that.playedAt,_that.result,_that.teamId,_that.teamName,_that.team,_that.brought,_that.leads,_that.opponentTeamId,_that.opponentTeamName,_that.opponentTeam,_that.opponentBrought,_that.opponentLeads,_that.mistake,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime playedAt,  GameResult result,  String? teamId,  String? teamName,  List<String> team,  List<String> brought,  List<String> leads,  String? opponentTeamId,  String? opponentTeamName,  List<String> opponentTeam,  List<String> opponentBrought,  List<String> opponentLeads,  MistakeCategory? mistake,  String notes)  $default,) {final _that = this;
switch (_that) {
case _GameLog():
return $default(_that.id,_that.playedAt,_that.result,_that.teamId,_that.teamName,_that.team,_that.brought,_that.leads,_that.opponentTeamId,_that.opponentTeamName,_that.opponentTeam,_that.opponentBrought,_that.opponentLeads,_that.mistake,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime playedAt,  GameResult result,  String? teamId,  String? teamName,  List<String> team,  List<String> brought,  List<String> leads,  String? opponentTeamId,  String? opponentTeamName,  List<String> opponentTeam,  List<String> opponentBrought,  List<String> opponentLeads,  MistakeCategory? mistake,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _GameLog() when $default != null:
return $default(_that.id,_that.playedAt,_that.result,_that.teamId,_that.teamName,_that.team,_that.brought,_that.leads,_that.opponentTeamId,_that.opponentTeamName,_that.opponentTeam,_that.opponentBrought,_that.opponentLeads,_that.mistake,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameLog implements GameLog {
  const _GameLog({required this.id, required this.playedAt, required this.result, this.teamId, this.teamName,  List<String> team = const [],  List<String> brought = const [],  List<String> leads = const [], this.opponentTeamId, this.opponentTeamName,  List<String> opponentTeam = const [],  List<String> opponentBrought = const [],  List<String> opponentLeads = const [], this.mistake, this.notes = ''}): _team = team,_brought = brought,_leads = leads,_opponentTeam = opponentTeam,_opponentBrought = opponentBrought,_opponentLeads = opponentLeads;
  factory _GameLog.fromJson(Map<String, dynamic> json) => _$GameLogFromJson(json);

@override final  String id;
@override final  DateTime playedAt;
@override final  GameResult result;
@override final  String? teamId;
@override final  String? teamName;
/// The full six of the team used; empty when no saved team was picked.
 final  List<String> _team;
/// The full six of the team used; empty when no saved team was picked.
@override@JsonKey() List<String> get team {
  if (_team is EqualUnmodifiableListView) return _team;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_team);
}

 final  List<String> _brought;
@override@JsonKey() List<String> get brought {
  if (_brought is EqualUnmodifiableListView) return _brought;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_brought);
}

 final  List<String> _leads;
@override@JsonKey() List<String> get leads {
  if (_leads is EqualUnmodifiableListView) return _leads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leads);
}

/// The saved opponent team this game was against, if one was picked.
/// Its name is kept too, so a deleted team still reads well.
@override final  String? opponentTeamId;
@override final  String? opponentTeamName;
 final  List<String> _opponentTeam;
@override@JsonKey() List<String> get opponentTeam {
  if (_opponentTeam is EqualUnmodifiableListView) return _opponentTeam;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_opponentTeam);
}

 final  List<String> _opponentBrought;
@override@JsonKey() List<String> get opponentBrought {
  if (_opponentBrought is EqualUnmodifiableListView) return _opponentBrought;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_opponentBrought);
}

 final  List<String> _opponentLeads;
@override@JsonKey() List<String> get opponentLeads {
  if (_opponentLeads is EqualUnmodifiableListView) return _opponentLeads;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_opponentLeads);
}

/// "What decided this game?", when answered.
@override final  MistakeCategory? mistake;
@override@JsonKey() final  String notes;

/// Create a copy of GameLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameLogCopyWith<_GameLog> get copyWith => __$GameLogCopyWithImpl<_GameLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameLog&&(identical(other.id, id) || other.id == id)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt)&&(identical(other.result, result) || other.result == result)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.teamName, teamName) || other.teamName == teamName)&&const DeepCollectionEquality().equals(other.team, _team)&&const DeepCollectionEquality().equals(other.brought, _brought)&&const DeepCollectionEquality().equals(other.leads, _leads)&&(identical(other.opponentTeamId, opponentTeamId) || other.opponentTeamId == opponentTeamId)&&(identical(other.opponentTeamName, opponentTeamName) || other.opponentTeamName == opponentTeamName)&&const DeepCollectionEquality().equals(other.opponentTeam, _opponentTeam)&&const DeepCollectionEquality().equals(other.opponentBrought, _opponentBrought)&&const DeepCollectionEquality().equals(other.opponentLeads, _opponentLeads)&&(identical(other.mistake, mistake) || other.mistake == mistake)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,playedAt,result,teamId,teamName,const DeepCollectionEquality().hash(_team),const DeepCollectionEquality().hash(_brought),const DeepCollectionEquality().hash(_leads),opponentTeamId,opponentTeamName,const DeepCollectionEquality().hash(_opponentTeam),const DeepCollectionEquality().hash(_opponentBrought),const DeepCollectionEquality().hash(_opponentLeads),mistake,notes);
}

@override
String toString() {
    return 'GameLog(id: $id, playedAt: $playedAt, result: $result, teamId: $teamId, teamName: $teamName, team: $team, brought: $brought, leads: $leads, opponentTeamId: $opponentTeamId, opponentTeamName: $opponentTeamName, opponentTeam: $opponentTeam, opponentBrought: $opponentBrought, opponentLeads: $opponentLeads, mistake: $mistake, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$GameLogCopyWith<$Res> implements $GameLogCopyWith<$Res> {
  factory _$GameLogCopyWith(_GameLog value, $Res Function(_GameLog) _then) = __$GameLogCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime playedAt, GameResult result, String? teamId, String? teamName, List<String> team, List<String> brought, List<String> leads, String? opponentTeamId, String? opponentTeamName, List<String> opponentTeam, List<String> opponentBrought, List<String> opponentLeads, MistakeCategory? mistake, String notes
});




}
/// @nodoc
class __$GameLogCopyWithImpl<$Res>
    implements _$GameLogCopyWith<$Res> {
  __$GameLogCopyWithImpl(this._self, this._then);

  final _GameLog _self;
  final $Res Function(_GameLog) _then;

/// Create a copy of GameLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? playedAt = null,Object? result = null,Object? teamId = freezed,Object? teamName = freezed,Object? team = null,Object? brought = null,Object? leads = null,Object? opponentTeamId = freezed,Object? opponentTeamName = freezed,Object? opponentTeam = null,Object? opponentBrought = null,Object? opponentLeads = null,Object? mistake = freezed,Object? notes = null,}) {
  return _then(_GameLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as GameResult,teamId: freezed == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String?,teamName: freezed == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String?,team: null == team ? _self._team : team // ignore: cast_nullable_to_non_nullable
as List<String>,brought: null == brought ? _self._brought : brought // ignore: cast_nullable_to_non_nullable
as List<String>,leads: null == leads ? _self._leads : leads // ignore: cast_nullable_to_non_nullable
as List<String>,opponentTeamId: freezed == opponentTeamId ? _self.opponentTeamId : opponentTeamId // ignore: cast_nullable_to_non_nullable
as String?,opponentTeamName: freezed == opponentTeamName ? _self.opponentTeamName : opponentTeamName // ignore: cast_nullable_to_non_nullable
as String?,opponentTeam: null == opponentTeam ? _self._opponentTeam : opponentTeam // ignore: cast_nullable_to_non_nullable
as List<String>,opponentBrought: null == opponentBrought ? _self._opponentBrought : opponentBrought // ignore: cast_nullable_to_non_nullable
as List<String>,opponentLeads: null == opponentLeads ? _self._opponentLeads : opponentLeads // ignore: cast_nullable_to_non_nullable
as List<String>,mistake: freezed == mistake ? _self.mistake : mistake // ignore: cast_nullable_to_non_nullable
as MistakeCategory?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
