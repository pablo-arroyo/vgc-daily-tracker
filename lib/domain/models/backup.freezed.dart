// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Backup {

 DateTime get exportedAt; List<Team> get teams; List<GameLog> get games;/// Ticked routine item ids per local day, e.g. `2026-09-30`.
 Map<String, List<String>> get routine;
/// Create a copy of Backup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupCopyWith<Backup> get copyWith => _$BackupCopyWithImpl<Backup>(this as Backup, _$identity);

  /// Serializes this Backup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Backup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Backup&&(identical(other.exportedAt, _this.exportedAt) || other.exportedAt == _this.exportedAt)&&const DeepCollectionEquality().equals(other.teams, _this.teams)&&const DeepCollectionEquality().equals(other.games, _this.games)&&const DeepCollectionEquality().equals(other.routine, _this.routine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Backup;
  return Object.hash(runtimeType,_this.exportedAt,const DeepCollectionEquality().hash(_this.teams),const DeepCollectionEquality().hash(_this.games),const DeepCollectionEquality().hash(_this.routine));
}

@override
String toString() {
  final _this = this as Backup;
  return 'Backup(exportedAt: ${_this.exportedAt}, teams: ${_this.teams}, games: ${_this.games}, routine: ${_this.routine})';
}


}

/// @nodoc
abstract mixin class $BackupCopyWith<$Res>  {
  factory $BackupCopyWith(Backup value, $Res Function(Backup) _then) = _$BackupCopyWithImpl;
@useResult
$Res call({
 DateTime exportedAt, List<Team> teams, List<GameLog> games, Map<String, List<String>> routine
});




}
/// @nodoc
class _$BackupCopyWithImpl<$Res>
    implements $BackupCopyWith<$Res> {
  _$BackupCopyWithImpl(this._self, this._then);

  final Backup _self;
  final $Res Function(Backup) _then;

/// Create a copy of Backup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exportedAt = null,Object? teams = null,Object? games = null,Object? routine = null,}) {
  return _then(Backup(
exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,teams: null == teams ? _self.teams : teams // ignore: cast_nullable_to_non_nullable
as List<Team>,games: null == games ? _self.games : games // ignore: cast_nullable_to_non_nullable
as List<GameLog>,routine: null == routine ? _self.routine : routine // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,
  ));
}

}


/// Adds pattern-matching-related methods to [Backup].
extension BackupPatterns on Backup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Backup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Backup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Backup value)  $default,){
final _that = this;
switch (_that) {
case _Backup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Backup value)?  $default,){
final _that = this;
switch (_that) {
case _Backup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime exportedAt,  List<Team> teams,  List<GameLog> games,  Map<String, List<String>> routine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Backup() when $default != null:
return $default(_that.exportedAt,_that.teams,_that.games,_that.routine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime exportedAt,  List<Team> teams,  List<GameLog> games,  Map<String, List<String>> routine)  $default,) {final _that = this;
switch (_that) {
case _Backup():
return $default(_that.exportedAt,_that.teams,_that.games,_that.routine);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime exportedAt,  List<Team> teams,  List<GameLog> games,  Map<String, List<String>> routine)?  $default,) {final _that = this;
switch (_that) {
case _Backup() when $default != null:
return $default(_that.exportedAt,_that.teams,_that.games,_that.routine);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Backup implements Backup {
  const _Backup({required this.exportedAt, required  List<Team> teams, required  List<GameLog> games, required  Map<String, List<String>> routine}): _teams = teams,_games = games,_routine = routine;
  factory _Backup.fromJson(Map<String, dynamic> json) => _$BackupFromJson(json);

@override final  DateTime exportedAt;
 final  List<Team> _teams;
@override List<Team> get teams {
  if (_teams is EqualUnmodifiableListView) return _teams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teams);
}

 final  List<GameLog> _games;
@override List<GameLog> get games {
  if (_games is EqualUnmodifiableListView) return _games;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_games);
}

/// Ticked routine item ids per local day, e.g. `2026-09-30`.
 final  Map<String, List<String>> _routine;
/// Ticked routine item ids per local day, e.g. `2026-09-30`.
@override Map<String, List<String>> get routine {
  if (_routine is EqualUnmodifiableMapView) return _routine;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_routine);
}


/// Create a copy of Backup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupCopyWith<_Backup> get copyWith => __$BackupCopyWithImpl<_Backup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Backup&&(identical(other.exportedAt, exportedAt) || other.exportedAt == exportedAt)&&const DeepCollectionEquality().equals(other.teams, _teams)&&const DeepCollectionEquality().equals(other.games, _games)&&const DeepCollectionEquality().equals(other.routine, _routine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,exportedAt,const DeepCollectionEquality().hash(_teams),const DeepCollectionEquality().hash(_games),const DeepCollectionEquality().hash(_routine));
}

@override
String toString() {
    return 'Backup(exportedAt: $exportedAt, teams: $teams, games: $games, routine: $routine)';
}


}

/// @nodoc
abstract mixin class _$BackupCopyWith<$Res> implements $BackupCopyWith<$Res> {
  factory _$BackupCopyWith(_Backup value, $Res Function(_Backup) _then) = __$BackupCopyWithImpl;
@override @useResult
$Res call({
 DateTime exportedAt, List<Team> teams, List<GameLog> games, Map<String, List<String>> routine
});




}
/// @nodoc
class __$BackupCopyWithImpl<$Res>
    implements _$BackupCopyWith<$Res> {
  __$BackupCopyWithImpl(this._self, this._then);

  final _Backup _self;
  final $Res Function(_Backup) _then;

/// Create a copy of Backup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exportedAt = null,Object? teams = null,Object? games = null,Object? routine = null,}) {
  return _then(_Backup(
exportedAt: null == exportedAt ? _self.exportedAt : exportedAt // ignore: cast_nullable_to_non_nullable
as DateTime,teams: null == teams ? _self._teams : teams // ignore: cast_nullable_to_non_nullable
as List<Team>,games: null == games ? _self._games : games // ignore: cast_nullable_to_non_nullable
as List<GameLog>,routine: null == routine ? _self._routine : routine // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,
  ));
}


}

// dart format on
