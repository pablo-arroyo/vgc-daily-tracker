// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'matchup_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MatchupNote {

 String get myTeamId; String get opponentTeamId; String get notes; DateTime get updatedAt;
/// Create a copy of MatchupNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchupNoteCopyWith<MatchupNote> get copyWith => _$MatchupNoteCopyWithImpl<MatchupNote>(this as MatchupNote, _$identity);

  /// Serializes this MatchupNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MatchupNote;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchupNote&&(identical(other.myTeamId, _this.myTeamId) || other.myTeamId == _this.myTeamId)&&(identical(other.opponentTeamId, _this.opponentTeamId) || other.opponentTeamId == _this.opponentTeamId)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MatchupNote;
  return Object.hash(runtimeType,_this.myTeamId,_this.opponentTeamId,_this.notes,_this.updatedAt);
}

@override
String toString() {
  final _this = this as MatchupNote;
  return 'MatchupNote(myTeamId: ${_this.myTeamId}, opponentTeamId: ${_this.opponentTeamId}, notes: ${_this.notes}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $MatchupNoteCopyWith<$Res>  {
  factory $MatchupNoteCopyWith(MatchupNote value, $Res Function(MatchupNote) _then) = _$MatchupNoteCopyWithImpl;
@useResult
$Res call({
 String myTeamId, String opponentTeamId, String notes, DateTime updatedAt
});




}
/// @nodoc
class _$MatchupNoteCopyWithImpl<$Res>
    implements $MatchupNoteCopyWith<$Res> {
  _$MatchupNoteCopyWithImpl(this._self, this._then);

  final MatchupNote _self;
  final $Res Function(MatchupNote) _then;

/// Create a copy of MatchupNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? myTeamId = null,Object? opponentTeamId = null,Object? notes = null,Object? updatedAt = null,}) {
  return _then(MatchupNote(
myTeamId: null == myTeamId ? _self.myTeamId : myTeamId // ignore: cast_nullable_to_non_nullable
as String,opponentTeamId: null == opponentTeamId ? _self.opponentTeamId : opponentTeamId // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchupNote].
extension MatchupNotePatterns on MatchupNote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchupNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchupNote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchupNote value)  $default,){
final _that = this;
switch (_that) {
case _MatchupNote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchupNote value)?  $default,){
final _that = this;
switch (_that) {
case _MatchupNote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String myTeamId,  String opponentTeamId,  String notes,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchupNote() when $default != null:
return $default(_that.myTeamId,_that.opponentTeamId,_that.notes,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String myTeamId,  String opponentTeamId,  String notes,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MatchupNote():
return $default(_that.myTeamId,_that.opponentTeamId,_that.notes,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String myTeamId,  String opponentTeamId,  String notes,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MatchupNote() when $default != null:
return $default(_that.myTeamId,_that.opponentTeamId,_that.notes,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchupNote extends MatchupNote {
  const _MatchupNote({required this.myTeamId, required this.opponentTeamId, required this.notes, required this.updatedAt}): super._();
  factory _MatchupNote.fromJson(Map<String, dynamic> json) => _$MatchupNoteFromJson(json);

@override final  String myTeamId;
@override final  String opponentTeamId;
@override final  String notes;
@override final  DateTime updatedAt;

/// Create a copy of MatchupNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchupNoteCopyWith<_MatchupNote> get copyWith => __$MatchupNoteCopyWithImpl<_MatchupNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchupNoteToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchupNote&&(identical(other.myTeamId, myTeamId) || other.myTeamId == myTeamId)&&(identical(other.opponentTeamId, opponentTeamId) || other.opponentTeamId == opponentTeamId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,myTeamId,opponentTeamId,notes,updatedAt);
}

@override
String toString() {
    return 'MatchupNote(myTeamId: $myTeamId, opponentTeamId: $opponentTeamId, notes: $notes, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MatchupNoteCopyWith<$Res> implements $MatchupNoteCopyWith<$Res> {
  factory _$MatchupNoteCopyWith(_MatchupNote value, $Res Function(_MatchupNote) _then) = __$MatchupNoteCopyWithImpl;
@override @useResult
$Res call({
 String myTeamId, String opponentTeamId, String notes, DateTime updatedAt
});




}
/// @nodoc
class __$MatchupNoteCopyWithImpl<$Res>
    implements _$MatchupNoteCopyWith<$Res> {
  __$MatchupNoteCopyWithImpl(this._self, this._then);

  final _MatchupNote _self;
  final $Res Function(_MatchupNote) _then;

/// Create a copy of MatchupNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? myTeamId = null,Object? opponentTeamId = null,Object? notes = null,Object? updatedAt = null,}) {
  return _then(_MatchupNote(
myTeamId: null == myTeamId ? _self.myTeamId : myTeamId // ignore: cast_nullable_to_non_nullable
as String,opponentTeamId: null == opponentTeamId ? _self.opponentTeamId : opponentTeamId // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
