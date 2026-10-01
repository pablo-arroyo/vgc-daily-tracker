// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speed_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeedEntry {

 SpeedSide get side; String get name; int get min; int get max; bool get tie;
/// Create a copy of SpeedEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeedEntryCopyWith<SpeedEntry> get copyWith => _$SpeedEntryCopyWithImpl<SpeedEntry>(this as SpeedEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SpeedEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeedEntry&&(identical(other.side, _this.side) || other.side == _this.side)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.min, _this.min) || other.min == _this.min)&&(identical(other.max, _this.max) || other.max == _this.max)&&(identical(other.tie, _this.tie) || other.tie == _this.tie));
}


@override
int get hashCode {
  final _this = this as SpeedEntry;
  return Object.hash(runtimeType,_this.side,_this.name,_this.min,_this.max,_this.tie);
}

@override
String toString() {
  final _this = this as SpeedEntry;
  return 'SpeedEntry(side: ${_this.side}, name: ${_this.name}, min: ${_this.min}, max: ${_this.max}, tie: ${_this.tie})';
}


}

/// @nodoc
abstract mixin class $SpeedEntryCopyWith<$Res>  {
  factory $SpeedEntryCopyWith(SpeedEntry value, $Res Function(SpeedEntry) _then) = _$SpeedEntryCopyWithImpl;
@useResult
$Res call({
 SpeedSide side, String name, int min, int max, bool tie
});




}
/// @nodoc
class _$SpeedEntryCopyWithImpl<$Res>
    implements $SpeedEntryCopyWith<$Res> {
  _$SpeedEntryCopyWithImpl(this._self, this._then);

  final SpeedEntry _self;
  final $Res Function(SpeedEntry) _then;

/// Create a copy of SpeedEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? side = null,Object? name = null,Object? min = null,Object? max = null,Object? tie = null,}) {
  return _then(SpeedEntry(
side: null == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as SpeedSide,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,tie: null == tie ? _self.tie : tie // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeedEntry].
extension SpeedEntryPatterns on SpeedEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeedEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeedEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeedEntry value)  $default,){
final _that = this;
switch (_that) {
case _SpeedEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeedEntry value)?  $default,){
final _that = this;
switch (_that) {
case _SpeedEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SpeedSide side,  String name,  int min,  int max,  bool tie)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeedEntry() when $default != null:
return $default(_that.side,_that.name,_that.min,_that.max,_that.tie);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SpeedSide side,  String name,  int min,  int max,  bool tie)  $default,) {final _that = this;
switch (_that) {
case _SpeedEntry():
return $default(_that.side,_that.name,_that.min,_that.max,_that.tie);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SpeedSide side,  String name,  int min,  int max,  bool tie)?  $default,) {final _that = this;
switch (_that) {
case _SpeedEntry() when $default != null:
return $default(_that.side,_that.name,_that.min,_that.max,_that.tie);case _:
  return null;

}
}

}

/// @nodoc


class _SpeedEntry implements SpeedEntry {
  const _SpeedEntry({required this.side, required this.name, required this.min, required this.max, this.tie = false});
  

@override final  SpeedSide side;
@override final  String name;
@override final  int min;
@override final  int max;
@override@JsonKey() final  bool tie;

/// Create a copy of SpeedEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeedEntryCopyWith<_SpeedEntry> get copyWith => __$SpeedEntryCopyWithImpl<_SpeedEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeedEntry&&(identical(other.side, side) || other.side == side)&&(identical(other.name, name) || other.name == name)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.tie, tie) || other.tie == tie));
}


@override
int get hashCode {
    return Object.hash(runtimeType,side,name,min,max,tie);
}

@override
String toString() {
    return 'SpeedEntry(side: $side, name: $name, min: $min, max: $max, tie: $tie)';
}


}

/// @nodoc
abstract mixin class _$SpeedEntryCopyWith<$Res> implements $SpeedEntryCopyWith<$Res> {
  factory _$SpeedEntryCopyWith(_SpeedEntry value, $Res Function(_SpeedEntry) _then) = __$SpeedEntryCopyWithImpl;
@override @useResult
$Res call({
 SpeedSide side, String name, int min, int max, bool tie
});




}
/// @nodoc
class __$SpeedEntryCopyWithImpl<$Res>
    implements _$SpeedEntryCopyWith<$Res> {
  __$SpeedEntryCopyWithImpl(this._self, this._then);

  final _SpeedEntry _self;
  final $Res Function(_SpeedEntry) _then;

/// Create a copy of SpeedEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? side = null,Object? name = null,Object? min = null,Object? max = null,Object? tie = null,}) {
  return _then(_SpeedEntry(
side: null == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as SpeedSide,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as int,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as int,tie: null == tie ? _self.tie : tie // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
