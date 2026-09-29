// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pokemon_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PokemonRef {

 int get id; String get slug; String get displayName;
/// Create a copy of PokemonRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PokemonRefCopyWith<PokemonRef> get copyWith => _$PokemonRefCopyWithImpl<PokemonRef>(this as PokemonRef, _$identity);

  /// Serializes this PokemonRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PokemonRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PokemonRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PokemonRef;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.displayName);
}

@override
String toString() {
  final _this = this as PokemonRef;
  return 'PokemonRef(id: ${_this.id}, slug: ${_this.slug}, displayName: ${_this.displayName})';
}


}

/// @nodoc
abstract mixin class $PokemonRefCopyWith<$Res>  {
  factory $PokemonRefCopyWith(PokemonRef value, $Res Function(PokemonRef) _then) = _$PokemonRefCopyWithImpl;
@useResult
$Res call({
 int id, String slug, String displayName
});




}
/// @nodoc
class _$PokemonRefCopyWithImpl<$Res>
    implements $PokemonRefCopyWith<$Res> {
  _$PokemonRefCopyWithImpl(this._self, this._then);

  final PokemonRef _self;
  final $Res Function(PokemonRef) _then;

/// Create a copy of PokemonRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? displayName = null,}) {
  return _then(PokemonRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PokemonRef].
extension PokemonRefPatterns on PokemonRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PokemonRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PokemonRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PokemonRef value)  $default,){
final _that = this;
switch (_that) {
case _PokemonRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PokemonRef value)?  $default,){
final _that = this;
switch (_that) {
case _PokemonRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String slug,  String displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PokemonRef() when $default != null:
return $default(_that.id,_that.slug,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String slug,  String displayName)  $default,) {final _that = this;
switch (_that) {
case _PokemonRef():
return $default(_that.id,_that.slug,_that.displayName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String slug,  String displayName)?  $default,) {final _that = this;
switch (_that) {
case _PokemonRef() when $default != null:
return $default(_that.id,_that.slug,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PokemonRef extends PokemonRef {
  const _PokemonRef({required this.id, required this.slug, required this.displayName}): super._();
  factory _PokemonRef.fromJson(Map<String, dynamic> json) => _$PokemonRefFromJson(json);

@override final  int id;
@override final  String slug;
@override final  String displayName;

/// Create a copy of PokemonRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PokemonRefCopyWith<_PokemonRef> get copyWith => __$PokemonRefCopyWithImpl<_PokemonRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PokemonRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PokemonRef&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,displayName);
}

@override
String toString() {
    return 'PokemonRef(id: $id, slug: $slug, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$PokemonRefCopyWith<$Res> implements $PokemonRefCopyWith<$Res> {
  factory _$PokemonRefCopyWith(_PokemonRef value, $Res Function(_PokemonRef) _then) = __$PokemonRefCopyWithImpl;
@override @useResult
$Res call({
 int id, String slug, String displayName
});




}
/// @nodoc
class __$PokemonRefCopyWithImpl<$Res>
    implements _$PokemonRefCopyWith<$Res> {
  __$PokemonRefCopyWithImpl(this._self, this._then);

  final _PokemonRef _self;
  final $Res Function(_PokemonRef) _then;

/// Create a copy of PokemonRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? displayName = null,}) {
  return _then(_PokemonRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
