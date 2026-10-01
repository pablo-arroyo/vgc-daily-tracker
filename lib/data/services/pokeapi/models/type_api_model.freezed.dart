// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'type_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TypeApiModel {

 int get id; String get name; DamageRelationsApiModel get damageRelations;
/// Create a copy of TypeApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TypeApiModelCopyWith<TypeApiModel> get copyWith => _$TypeApiModelCopyWithImpl<TypeApiModel>(this as TypeApiModel, _$identity);

  /// Serializes this TypeApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TypeApiModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TypeApiModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.damageRelations, _this.damageRelations) || other.damageRelations == _this.damageRelations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TypeApiModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.damageRelations);
}

@override
String toString() {
  final _this = this as TypeApiModel;
  return 'TypeApiModel(id: ${_this.id}, name: ${_this.name}, damageRelations: ${_this.damageRelations})';
}


}

/// @nodoc
abstract mixin class $TypeApiModelCopyWith<$Res>  {
  factory $TypeApiModelCopyWith(TypeApiModel value, $Res Function(TypeApiModel) _then) = _$TypeApiModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, DamageRelationsApiModel damageRelations
});


$DamageRelationsApiModelCopyWith<$Res> get damageRelations;

}
/// @nodoc
class _$TypeApiModelCopyWithImpl<$Res>
    implements $TypeApiModelCopyWith<$Res> {
  _$TypeApiModelCopyWithImpl(this._self, this._then);

  final TypeApiModel _self;
  final $Res Function(TypeApiModel) _then;

/// Create a copy of TypeApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? damageRelations = null,}) {
  return _then(TypeApiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,damageRelations: null == damageRelations ? _self.damageRelations : damageRelations // ignore: cast_nullable_to_non_nullable
as DamageRelationsApiModel,
  ));
}
/// Create a copy of TypeApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DamageRelationsApiModelCopyWith<$Res> get damageRelations {
  
  return $DamageRelationsApiModelCopyWith<$Res>(_self.damageRelations, (value) {
    return _then(_self.copyWith(damageRelations: value));
  });
}
}


/// Adds pattern-matching-related methods to [TypeApiModel].
extension TypeApiModelPatterns on TypeApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TypeApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TypeApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TypeApiModel value)  $default,){
final _that = this;
switch (_that) {
case _TypeApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TypeApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _TypeApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  DamageRelationsApiModel damageRelations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TypeApiModel() when $default != null:
return $default(_that.id,_that.name,_that.damageRelations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  DamageRelationsApiModel damageRelations)  $default,) {final _that = this;
switch (_that) {
case _TypeApiModel():
return $default(_that.id,_that.name,_that.damageRelations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  DamageRelationsApiModel damageRelations)?  $default,) {final _that = this;
switch (_that) {
case _TypeApiModel() when $default != null:
return $default(_that.id,_that.name,_that.damageRelations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TypeApiModel implements TypeApiModel {
  const _TypeApiModel({required this.id, required this.name, required this.damageRelations});
  factory _TypeApiModel.fromJson(Map<String, dynamic> json) => _$TypeApiModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  DamageRelationsApiModel damageRelations;

/// Create a copy of TypeApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypeApiModelCopyWith<_TypeApiModel> get copyWith => __$TypeApiModelCopyWithImpl<_TypeApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TypeApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypeApiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.damageRelations, damageRelations) || other.damageRelations == damageRelations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,damageRelations);
}

@override
String toString() {
    return 'TypeApiModel(id: $id, name: $name, damageRelations: $damageRelations)';
}


}

/// @nodoc
abstract mixin class _$TypeApiModelCopyWith<$Res> implements $TypeApiModelCopyWith<$Res> {
  factory _$TypeApiModelCopyWith(_TypeApiModel value, $Res Function(_TypeApiModel) _then) = __$TypeApiModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, DamageRelationsApiModel damageRelations
});


@override $DamageRelationsApiModelCopyWith<$Res> get damageRelations;

}
/// @nodoc
class __$TypeApiModelCopyWithImpl<$Res>
    implements _$TypeApiModelCopyWith<$Res> {
  __$TypeApiModelCopyWithImpl(this._self, this._then);

  final _TypeApiModel _self;
  final $Res Function(_TypeApiModel) _then;

/// Create a copy of TypeApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? damageRelations = null,}) {
  return _then(_TypeApiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,damageRelations: null == damageRelations ? _self.damageRelations : damageRelations // ignore: cast_nullable_to_non_nullable
as DamageRelationsApiModel,
  ));
}

/// Create a copy of TypeApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DamageRelationsApiModelCopyWith<$Res> get damageRelations {
  
  return $DamageRelationsApiModelCopyWith<$Res>(_self.damageRelations, (value) {
    return _then(_self.copyWith(damageRelations: value));
  });
}
}


/// @nodoc
mixin _$DamageRelationsApiModel {

 List<NamedApiResource> get doubleDamageTo; List<NamedApiResource> get halfDamageTo; List<NamedApiResource> get noDamageTo;
/// Create a copy of DamageRelationsApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DamageRelationsApiModelCopyWith<DamageRelationsApiModel> get copyWith => _$DamageRelationsApiModelCopyWithImpl<DamageRelationsApiModel>(this as DamageRelationsApiModel, _$identity);

  /// Serializes this DamageRelationsApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DamageRelationsApiModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DamageRelationsApiModel&&const DeepCollectionEquality().equals(other.doubleDamageTo, _this.doubleDamageTo)&&const DeepCollectionEquality().equals(other.halfDamageTo, _this.halfDamageTo)&&const DeepCollectionEquality().equals(other.noDamageTo, _this.noDamageTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DamageRelationsApiModel;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.doubleDamageTo),const DeepCollectionEquality().hash(_this.halfDamageTo),const DeepCollectionEquality().hash(_this.noDamageTo));
}

@override
String toString() {
  final _this = this as DamageRelationsApiModel;
  return 'DamageRelationsApiModel(doubleDamageTo: ${_this.doubleDamageTo}, halfDamageTo: ${_this.halfDamageTo}, noDamageTo: ${_this.noDamageTo})';
}


}

/// @nodoc
abstract mixin class $DamageRelationsApiModelCopyWith<$Res>  {
  factory $DamageRelationsApiModelCopyWith(DamageRelationsApiModel value, $Res Function(DamageRelationsApiModel) _then) = _$DamageRelationsApiModelCopyWithImpl;
@useResult
$Res call({
 List<NamedApiResource> doubleDamageTo, List<NamedApiResource> halfDamageTo, List<NamedApiResource> noDamageTo
});




}
/// @nodoc
class _$DamageRelationsApiModelCopyWithImpl<$Res>
    implements $DamageRelationsApiModelCopyWith<$Res> {
  _$DamageRelationsApiModelCopyWithImpl(this._self, this._then);

  final DamageRelationsApiModel _self;
  final $Res Function(DamageRelationsApiModel) _then;

/// Create a copy of DamageRelationsApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? doubleDamageTo = null,Object? halfDamageTo = null,Object? noDamageTo = null,}) {
  return _then(DamageRelationsApiModel(
doubleDamageTo: null == doubleDamageTo ? _self.doubleDamageTo : doubleDamageTo // ignore: cast_nullable_to_non_nullable
as List<NamedApiResource>,halfDamageTo: null == halfDamageTo ? _self.halfDamageTo : halfDamageTo // ignore: cast_nullable_to_non_nullable
as List<NamedApiResource>,noDamageTo: null == noDamageTo ? _self.noDamageTo : noDamageTo // ignore: cast_nullable_to_non_nullable
as List<NamedApiResource>,
  ));
}

}


/// Adds pattern-matching-related methods to [DamageRelationsApiModel].
extension DamageRelationsApiModelPatterns on DamageRelationsApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DamageRelationsApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DamageRelationsApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DamageRelationsApiModel value)  $default,){
final _that = this;
switch (_that) {
case _DamageRelationsApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DamageRelationsApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _DamageRelationsApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NamedApiResource> doubleDamageTo,  List<NamedApiResource> halfDamageTo,  List<NamedApiResource> noDamageTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DamageRelationsApiModel() when $default != null:
return $default(_that.doubleDamageTo,_that.halfDamageTo,_that.noDamageTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NamedApiResource> doubleDamageTo,  List<NamedApiResource> halfDamageTo,  List<NamedApiResource> noDamageTo)  $default,) {final _that = this;
switch (_that) {
case _DamageRelationsApiModel():
return $default(_that.doubleDamageTo,_that.halfDamageTo,_that.noDamageTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NamedApiResource> doubleDamageTo,  List<NamedApiResource> halfDamageTo,  List<NamedApiResource> noDamageTo)?  $default,) {final _that = this;
switch (_that) {
case _DamageRelationsApiModel() when $default != null:
return $default(_that.doubleDamageTo,_that.halfDamageTo,_that.noDamageTo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DamageRelationsApiModel implements DamageRelationsApiModel {
  const _DamageRelationsApiModel({required  List<NamedApiResource> doubleDamageTo, required  List<NamedApiResource> halfDamageTo, required  List<NamedApiResource> noDamageTo}): _doubleDamageTo = doubleDamageTo,_halfDamageTo = halfDamageTo,_noDamageTo = noDamageTo;
  factory _DamageRelationsApiModel.fromJson(Map<String, dynamic> json) => _$DamageRelationsApiModelFromJson(json);

 final  List<NamedApiResource> _doubleDamageTo;
@override List<NamedApiResource> get doubleDamageTo {
  if (_doubleDamageTo is EqualUnmodifiableListView) return _doubleDamageTo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_doubleDamageTo);
}

 final  List<NamedApiResource> _halfDamageTo;
@override List<NamedApiResource> get halfDamageTo {
  if (_halfDamageTo is EqualUnmodifiableListView) return _halfDamageTo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_halfDamageTo);
}

 final  List<NamedApiResource> _noDamageTo;
@override List<NamedApiResource> get noDamageTo {
  if (_noDamageTo is EqualUnmodifiableListView) return _noDamageTo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_noDamageTo);
}


/// Create a copy of DamageRelationsApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DamageRelationsApiModelCopyWith<_DamageRelationsApiModel> get copyWith => __$DamageRelationsApiModelCopyWithImpl<_DamageRelationsApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DamageRelationsApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DamageRelationsApiModel&&const DeepCollectionEquality().equals(other.doubleDamageTo, _doubleDamageTo)&&const DeepCollectionEquality().equals(other.halfDamageTo, _halfDamageTo)&&const DeepCollectionEquality().equals(other.noDamageTo, _noDamageTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_doubleDamageTo),const DeepCollectionEquality().hash(_halfDamageTo),const DeepCollectionEquality().hash(_noDamageTo));
}

@override
String toString() {
    return 'DamageRelationsApiModel(doubleDamageTo: $doubleDamageTo, halfDamageTo: $halfDamageTo, noDamageTo: $noDamageTo)';
}


}

/// @nodoc
abstract mixin class _$DamageRelationsApiModelCopyWith<$Res> implements $DamageRelationsApiModelCopyWith<$Res> {
  factory _$DamageRelationsApiModelCopyWith(_DamageRelationsApiModel value, $Res Function(_DamageRelationsApiModel) _then) = __$DamageRelationsApiModelCopyWithImpl;
@override @useResult
$Res call({
 List<NamedApiResource> doubleDamageTo, List<NamedApiResource> halfDamageTo, List<NamedApiResource> noDamageTo
});




}
/// @nodoc
class __$DamageRelationsApiModelCopyWithImpl<$Res>
    implements _$DamageRelationsApiModelCopyWith<$Res> {
  __$DamageRelationsApiModelCopyWithImpl(this._self, this._then);

  final _DamageRelationsApiModel _self;
  final $Res Function(_DamageRelationsApiModel) _then;

/// Create a copy of DamageRelationsApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? doubleDamageTo = null,Object? halfDamageTo = null,Object? noDamageTo = null,}) {
  return _then(_DamageRelationsApiModel(
doubleDamageTo: null == doubleDamageTo ? _self._doubleDamageTo : doubleDamageTo // ignore: cast_nullable_to_non_nullable
as List<NamedApiResource>,halfDamageTo: null == halfDamageTo ? _self._halfDamageTo : halfDamageTo // ignore: cast_nullable_to_non_nullable
as List<NamedApiResource>,noDamageTo: null == noDamageTo ? _self._noDamageTo : noDamageTo // ignore: cast_nullable_to_non_nullable
as List<NamedApiResource>,
  ));
}


}

// dart format on
