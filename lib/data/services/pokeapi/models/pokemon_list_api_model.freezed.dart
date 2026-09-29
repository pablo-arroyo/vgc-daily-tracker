// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pokemon_list_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PokemonListApiModel {

 int get count; List<NamedApiResource> get results;
/// Create a copy of PokemonListApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PokemonListApiModelCopyWith<PokemonListApiModel> get copyWith => _$PokemonListApiModelCopyWithImpl<PokemonListApiModel>(this as PokemonListApiModel, _$identity);

  /// Serializes this PokemonListApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PokemonListApiModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PokemonListApiModel&&(identical(other.count, _this.count) || other.count == _this.count)&&const DeepCollectionEquality().equals(other.results, _this.results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PokemonListApiModel;
  return Object.hash(runtimeType,_this.count,const DeepCollectionEquality().hash(_this.results));
}

@override
String toString() {
  final _this = this as PokemonListApiModel;
  return 'PokemonListApiModel(count: ${_this.count}, results: ${_this.results})';
}


}

/// @nodoc
abstract mixin class $PokemonListApiModelCopyWith<$Res>  {
  factory $PokemonListApiModelCopyWith(PokemonListApiModel value, $Res Function(PokemonListApiModel) _then) = _$PokemonListApiModelCopyWithImpl;
@useResult
$Res call({
 int count, List<NamedApiResource> results
});




}
/// @nodoc
class _$PokemonListApiModelCopyWithImpl<$Res>
    implements $PokemonListApiModelCopyWith<$Res> {
  _$PokemonListApiModelCopyWithImpl(this._self, this._then);

  final PokemonListApiModel _self;
  final $Res Function(PokemonListApiModel) _then;

/// Create a copy of PokemonListApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? results = null,}) {
  return _then(PokemonListApiModel(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<NamedApiResource>,
  ));
}

}


/// Adds pattern-matching-related methods to [PokemonListApiModel].
extension PokemonListApiModelPatterns on PokemonListApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PokemonListApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PokemonListApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PokemonListApiModel value)  $default,){
final _that = this;
switch (_that) {
case _PokemonListApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PokemonListApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _PokemonListApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  List<NamedApiResource> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PokemonListApiModel() when $default != null:
return $default(_that.count,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  List<NamedApiResource> results)  $default,) {final _that = this;
switch (_that) {
case _PokemonListApiModel():
return $default(_that.count,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  List<NamedApiResource> results)?  $default,) {final _that = this;
switch (_that) {
case _PokemonListApiModel() when $default != null:
return $default(_that.count,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PokemonListApiModel implements PokemonListApiModel {
  const _PokemonListApiModel({required this.count, required  List<NamedApiResource> results}): _results = results;
  factory _PokemonListApiModel.fromJson(Map<String, dynamic> json) => _$PokemonListApiModelFromJson(json);

@override final  int count;
 final  List<NamedApiResource> _results;
@override List<NamedApiResource> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of PokemonListApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PokemonListApiModelCopyWith<_PokemonListApiModel> get copyWith => __$PokemonListApiModelCopyWithImpl<_PokemonListApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PokemonListApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PokemonListApiModel&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,count,const DeepCollectionEquality().hash(_results));
}

@override
String toString() {
    return 'PokemonListApiModel(count: $count, results: $results)';
}


}

/// @nodoc
abstract mixin class _$PokemonListApiModelCopyWith<$Res> implements $PokemonListApiModelCopyWith<$Res> {
  factory _$PokemonListApiModelCopyWith(_PokemonListApiModel value, $Res Function(_PokemonListApiModel) _then) = __$PokemonListApiModelCopyWithImpl;
@override @useResult
$Res call({
 int count, List<NamedApiResource> results
});




}
/// @nodoc
class __$PokemonListApiModelCopyWithImpl<$Res>
    implements _$PokemonListApiModelCopyWith<$Res> {
  __$PokemonListApiModelCopyWithImpl(this._self, this._then);

  final _PokemonListApiModel _self;
  final $Res Function(_PokemonListApiModel) _then;

/// Create a copy of PokemonListApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? results = null,}) {
  return _then(_PokemonListApiModel(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<NamedApiResource>,
  ));
}


}

// dart format on
