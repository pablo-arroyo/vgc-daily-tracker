// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'showdown_format.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShowdownIssue {

 int get line; String get message;
/// Create a copy of ShowdownIssue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShowdownIssueCopyWith<ShowdownIssue> get copyWith => _$ShowdownIssueCopyWithImpl<ShowdownIssue>(this as ShowdownIssue, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShowdownIssue;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShowdownIssue&&(identical(other.line, _this.line) || other.line == _this.line)&&(identical(other.message, _this.message) || other.message == _this.message));
}


@override
int get hashCode {
  final _this = this as ShowdownIssue;
  return Object.hash(runtimeType,_this.line,_this.message);
}

@override
String toString() {
  final _this = this as ShowdownIssue;
  return 'ShowdownIssue(line: ${_this.line}, message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $ShowdownIssueCopyWith<$Res>  {
  factory $ShowdownIssueCopyWith(ShowdownIssue value, $Res Function(ShowdownIssue) _then) = _$ShowdownIssueCopyWithImpl;
@useResult
$Res call({
 int line, String message
});




}
/// @nodoc
class _$ShowdownIssueCopyWithImpl<$Res>
    implements $ShowdownIssueCopyWith<$Res> {
  _$ShowdownIssueCopyWithImpl(this._self, this._then);

  final ShowdownIssue _self;
  final $Res Function(ShowdownIssue) _then;

/// Create a copy of ShowdownIssue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? line = null,Object? message = null,}) {
  return _then(ShowdownIssue(
line: null == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ShowdownIssue].
extension ShowdownIssuePatterns on ShowdownIssue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShowdownIssue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShowdownIssue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShowdownIssue value)  $default,){
final _that = this;
switch (_that) {
case _ShowdownIssue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShowdownIssue value)?  $default,){
final _that = this;
switch (_that) {
case _ShowdownIssue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int line,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShowdownIssue() when $default != null:
return $default(_that.line,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int line,  String message)  $default,) {final _that = this;
switch (_that) {
case _ShowdownIssue():
return $default(_that.line,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int line,  String message)?  $default,) {final _that = this;
switch (_that) {
case _ShowdownIssue() when $default != null:
return $default(_that.line,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _ShowdownIssue implements ShowdownIssue {
  const _ShowdownIssue({required this.line, required this.message});
  

@override final  int line;
@override final  String message;

/// Create a copy of ShowdownIssue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShowdownIssueCopyWith<_ShowdownIssue> get copyWith => __$ShowdownIssueCopyWithImpl<_ShowdownIssue>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShowdownIssue&&(identical(other.line, line) || other.line == line)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,line,message);
}

@override
String toString() {
    return 'ShowdownIssue(line: $line, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ShowdownIssueCopyWith<$Res> implements $ShowdownIssueCopyWith<$Res> {
  factory _$ShowdownIssueCopyWith(_ShowdownIssue value, $Res Function(_ShowdownIssue) _then) = __$ShowdownIssueCopyWithImpl;
@override @useResult
$Res call({
 int line, String message
});




}
/// @nodoc
class __$ShowdownIssueCopyWithImpl<$Res>
    implements _$ShowdownIssueCopyWith<$Res> {
  __$ShowdownIssueCopyWithImpl(this._self, this._then);

  final _ShowdownIssue _self;
  final $Res Function(_ShowdownIssue) _then;

/// Create a copy of ShowdownIssue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? line = null,Object? message = null,}) {
  return _then(_ShowdownIssue(
line: null == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
