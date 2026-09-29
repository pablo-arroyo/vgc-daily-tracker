// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pokemon_detail_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PokemonDetailApiModel {

 int get id; String get name; NamedApiResource get species; List<PokemonTypeSlotApiModel> get types; List<PokemonStatApiModel> get stats; List<PokemonAbilityApiModel> get abilities; PokemonSpritesApiModel get sprites;
/// Create a copy of PokemonDetailApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PokemonDetailApiModelCopyWith<PokemonDetailApiModel> get copyWith => _$PokemonDetailApiModelCopyWithImpl<PokemonDetailApiModel>(this as PokemonDetailApiModel, _$identity);

  /// Serializes this PokemonDetailApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PokemonDetailApiModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PokemonDetailApiModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.species, _this.species) || other.species == _this.species)&&const DeepCollectionEquality().equals(other.types, _this.types)&&const DeepCollectionEquality().equals(other.stats, _this.stats)&&const DeepCollectionEquality().equals(other.abilities, _this.abilities)&&(identical(other.sprites, _this.sprites) || other.sprites == _this.sprites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PokemonDetailApiModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.species,const DeepCollectionEquality().hash(_this.types),const DeepCollectionEquality().hash(_this.stats),const DeepCollectionEquality().hash(_this.abilities),_this.sprites);
}

@override
String toString() {
  final _this = this as PokemonDetailApiModel;
  return 'PokemonDetailApiModel(id: ${_this.id}, name: ${_this.name}, species: ${_this.species}, types: ${_this.types}, stats: ${_this.stats}, abilities: ${_this.abilities}, sprites: ${_this.sprites})';
}


}

/// @nodoc
abstract mixin class $PokemonDetailApiModelCopyWith<$Res>  {
  factory $PokemonDetailApiModelCopyWith(PokemonDetailApiModel value, $Res Function(PokemonDetailApiModel) _then) = _$PokemonDetailApiModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, NamedApiResource species, List<PokemonTypeSlotApiModel> types, List<PokemonStatApiModel> stats, List<PokemonAbilityApiModel> abilities, PokemonSpritesApiModel sprites
});


$NamedApiResourceCopyWith<$Res> get species;$PokemonSpritesApiModelCopyWith<$Res> get sprites;

}
/// @nodoc
class _$PokemonDetailApiModelCopyWithImpl<$Res>
    implements $PokemonDetailApiModelCopyWith<$Res> {
  _$PokemonDetailApiModelCopyWithImpl(this._self, this._then);

  final PokemonDetailApiModel _self;
  final $Res Function(PokemonDetailApiModel) _then;

/// Create a copy of PokemonDetailApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? species = null,Object? types = null,Object? stats = null,Object? abilities = null,Object? sprites = null,}) {
  return _then(PokemonDetailApiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as NamedApiResource,types: null == types ? _self.types : types // ignore: cast_nullable_to_non_nullable
as List<PokemonTypeSlotApiModel>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as List<PokemonStatApiModel>,abilities: null == abilities ? _self.abilities : abilities // ignore: cast_nullable_to_non_nullable
as List<PokemonAbilityApiModel>,sprites: null == sprites ? _self.sprites : sprites // ignore: cast_nullable_to_non_nullable
as PokemonSpritesApiModel,
  ));
}
/// Create a copy of PokemonDetailApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedApiResourceCopyWith<$Res> get species {
  
  return $NamedApiResourceCopyWith<$Res>(_self.species, (value) {
    return _then(_self.copyWith(species: value));
  });
}/// Create a copy of PokemonDetailApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PokemonSpritesApiModelCopyWith<$Res> get sprites {
  
  return $PokemonSpritesApiModelCopyWith<$Res>(_self.sprites, (value) {
    return _then(_self.copyWith(sprites: value));
  });
}
}


/// Adds pattern-matching-related methods to [PokemonDetailApiModel].
extension PokemonDetailApiModelPatterns on PokemonDetailApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PokemonDetailApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PokemonDetailApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PokemonDetailApiModel value)  $default,){
final _that = this;
switch (_that) {
case _PokemonDetailApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PokemonDetailApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _PokemonDetailApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  NamedApiResource species,  List<PokemonTypeSlotApiModel> types,  List<PokemonStatApiModel> stats,  List<PokemonAbilityApiModel> abilities,  PokemonSpritesApiModel sprites)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PokemonDetailApiModel() when $default != null:
return $default(_that.id,_that.name,_that.species,_that.types,_that.stats,_that.abilities,_that.sprites);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  NamedApiResource species,  List<PokemonTypeSlotApiModel> types,  List<PokemonStatApiModel> stats,  List<PokemonAbilityApiModel> abilities,  PokemonSpritesApiModel sprites)  $default,) {final _that = this;
switch (_that) {
case _PokemonDetailApiModel():
return $default(_that.id,_that.name,_that.species,_that.types,_that.stats,_that.abilities,_that.sprites);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  NamedApiResource species,  List<PokemonTypeSlotApiModel> types,  List<PokemonStatApiModel> stats,  List<PokemonAbilityApiModel> abilities,  PokemonSpritesApiModel sprites)?  $default,) {final _that = this;
switch (_that) {
case _PokemonDetailApiModel() when $default != null:
return $default(_that.id,_that.name,_that.species,_that.types,_that.stats,_that.abilities,_that.sprites);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PokemonDetailApiModel implements PokemonDetailApiModel {
  const _PokemonDetailApiModel({required this.id, required this.name, required this.species, required  List<PokemonTypeSlotApiModel> types, required  List<PokemonStatApiModel> stats, required  List<PokemonAbilityApiModel> abilities, required this.sprites}): _types = types,_stats = stats,_abilities = abilities;
  factory _PokemonDetailApiModel.fromJson(Map<String, dynamic> json) => _$PokemonDetailApiModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  NamedApiResource species;
 final  List<PokemonTypeSlotApiModel> _types;
@override List<PokemonTypeSlotApiModel> get types {
  if (_types is EqualUnmodifiableListView) return _types;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_types);
}

 final  List<PokemonStatApiModel> _stats;
@override List<PokemonStatApiModel> get stats {
  if (_stats is EqualUnmodifiableListView) return _stats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stats);
}

 final  List<PokemonAbilityApiModel> _abilities;
@override List<PokemonAbilityApiModel> get abilities {
  if (_abilities is EqualUnmodifiableListView) return _abilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_abilities);
}

@override final  PokemonSpritesApiModel sprites;

/// Create a copy of PokemonDetailApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PokemonDetailApiModelCopyWith<_PokemonDetailApiModel> get copyWith => __$PokemonDetailApiModelCopyWithImpl<_PokemonDetailApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PokemonDetailApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PokemonDetailApiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.species, species) || other.species == species)&&const DeepCollectionEquality().equals(other.types, _types)&&const DeepCollectionEquality().equals(other.stats, _stats)&&const DeepCollectionEquality().equals(other.abilities, _abilities)&&(identical(other.sprites, sprites) || other.sprites == sprites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,species,const DeepCollectionEquality().hash(_types),const DeepCollectionEquality().hash(_stats),const DeepCollectionEquality().hash(_abilities),sprites);
}

@override
String toString() {
    return 'PokemonDetailApiModel(id: $id, name: $name, species: $species, types: $types, stats: $stats, abilities: $abilities, sprites: $sprites)';
}


}

/// @nodoc
abstract mixin class _$PokemonDetailApiModelCopyWith<$Res> implements $PokemonDetailApiModelCopyWith<$Res> {
  factory _$PokemonDetailApiModelCopyWith(_PokemonDetailApiModel value, $Res Function(_PokemonDetailApiModel) _then) = __$PokemonDetailApiModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, NamedApiResource species, List<PokemonTypeSlotApiModel> types, List<PokemonStatApiModel> stats, List<PokemonAbilityApiModel> abilities, PokemonSpritesApiModel sprites
});


@override $NamedApiResourceCopyWith<$Res> get species;@override $PokemonSpritesApiModelCopyWith<$Res> get sprites;

}
/// @nodoc
class __$PokemonDetailApiModelCopyWithImpl<$Res>
    implements _$PokemonDetailApiModelCopyWith<$Res> {
  __$PokemonDetailApiModelCopyWithImpl(this._self, this._then);

  final _PokemonDetailApiModel _self;
  final $Res Function(_PokemonDetailApiModel) _then;

/// Create a copy of PokemonDetailApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? species = null,Object? types = null,Object? stats = null,Object? abilities = null,Object? sprites = null,}) {
  return _then(_PokemonDetailApiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as NamedApiResource,types: null == types ? _self._types : types // ignore: cast_nullable_to_non_nullable
as List<PokemonTypeSlotApiModel>,stats: null == stats ? _self._stats : stats // ignore: cast_nullable_to_non_nullable
as List<PokemonStatApiModel>,abilities: null == abilities ? _self._abilities : abilities // ignore: cast_nullable_to_non_nullable
as List<PokemonAbilityApiModel>,sprites: null == sprites ? _self.sprites : sprites // ignore: cast_nullable_to_non_nullable
as PokemonSpritesApiModel,
  ));
}

/// Create a copy of PokemonDetailApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedApiResourceCopyWith<$Res> get species {
  
  return $NamedApiResourceCopyWith<$Res>(_self.species, (value) {
    return _then(_self.copyWith(species: value));
  });
}/// Create a copy of PokemonDetailApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PokemonSpritesApiModelCopyWith<$Res> get sprites {
  
  return $PokemonSpritesApiModelCopyWith<$Res>(_self.sprites, (value) {
    return _then(_self.copyWith(sprites: value));
  });
}
}


/// @nodoc
mixin _$PokemonTypeSlotApiModel {

 int get slot; NamedApiResource get type;
/// Create a copy of PokemonTypeSlotApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PokemonTypeSlotApiModelCopyWith<PokemonTypeSlotApiModel> get copyWith => _$PokemonTypeSlotApiModelCopyWithImpl<PokemonTypeSlotApiModel>(this as PokemonTypeSlotApiModel, _$identity);

  /// Serializes this PokemonTypeSlotApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PokemonTypeSlotApiModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PokemonTypeSlotApiModel&&(identical(other.slot, _this.slot) || other.slot == _this.slot)&&(identical(other.type, _this.type) || other.type == _this.type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PokemonTypeSlotApiModel;
  return Object.hash(runtimeType,_this.slot,_this.type);
}

@override
String toString() {
  final _this = this as PokemonTypeSlotApiModel;
  return 'PokemonTypeSlotApiModel(slot: ${_this.slot}, type: ${_this.type})';
}


}

/// @nodoc
abstract mixin class $PokemonTypeSlotApiModelCopyWith<$Res>  {
  factory $PokemonTypeSlotApiModelCopyWith(PokemonTypeSlotApiModel value, $Res Function(PokemonTypeSlotApiModel) _then) = _$PokemonTypeSlotApiModelCopyWithImpl;
@useResult
$Res call({
 int slot, NamedApiResource type
});


$NamedApiResourceCopyWith<$Res> get type;

}
/// @nodoc
class _$PokemonTypeSlotApiModelCopyWithImpl<$Res>
    implements $PokemonTypeSlotApiModelCopyWith<$Res> {
  _$PokemonTypeSlotApiModelCopyWithImpl(this._self, this._then);

  final PokemonTypeSlotApiModel _self;
  final $Res Function(PokemonTypeSlotApiModel) _then;

/// Create a copy of PokemonTypeSlotApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slot = null,Object? type = null,}) {
  return _then(PokemonTypeSlotApiModel(
slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NamedApiResource,
  ));
}
/// Create a copy of PokemonTypeSlotApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedApiResourceCopyWith<$Res> get type {
  
  return $NamedApiResourceCopyWith<$Res>(_self.type, (value) {
    return _then(_self.copyWith(type: value));
  });
}
}


/// Adds pattern-matching-related methods to [PokemonTypeSlotApiModel].
extension PokemonTypeSlotApiModelPatterns on PokemonTypeSlotApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PokemonTypeSlotApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PokemonTypeSlotApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PokemonTypeSlotApiModel value)  $default,){
final _that = this;
switch (_that) {
case _PokemonTypeSlotApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PokemonTypeSlotApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _PokemonTypeSlotApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int slot,  NamedApiResource type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PokemonTypeSlotApiModel() when $default != null:
return $default(_that.slot,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int slot,  NamedApiResource type)  $default,) {final _that = this;
switch (_that) {
case _PokemonTypeSlotApiModel():
return $default(_that.slot,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int slot,  NamedApiResource type)?  $default,) {final _that = this;
switch (_that) {
case _PokemonTypeSlotApiModel() when $default != null:
return $default(_that.slot,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PokemonTypeSlotApiModel implements PokemonTypeSlotApiModel {
  const _PokemonTypeSlotApiModel({required this.slot, required this.type});
  factory _PokemonTypeSlotApiModel.fromJson(Map<String, dynamic> json) => _$PokemonTypeSlotApiModelFromJson(json);

@override final  int slot;
@override final  NamedApiResource type;

/// Create a copy of PokemonTypeSlotApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PokemonTypeSlotApiModelCopyWith<_PokemonTypeSlotApiModel> get copyWith => __$PokemonTypeSlotApiModelCopyWithImpl<_PokemonTypeSlotApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PokemonTypeSlotApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PokemonTypeSlotApiModel&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,slot,type);
}

@override
String toString() {
    return 'PokemonTypeSlotApiModel(slot: $slot, type: $type)';
}


}

/// @nodoc
abstract mixin class _$PokemonTypeSlotApiModelCopyWith<$Res> implements $PokemonTypeSlotApiModelCopyWith<$Res> {
  factory _$PokemonTypeSlotApiModelCopyWith(_PokemonTypeSlotApiModel value, $Res Function(_PokemonTypeSlotApiModel) _then) = __$PokemonTypeSlotApiModelCopyWithImpl;
@override @useResult
$Res call({
 int slot, NamedApiResource type
});


@override $NamedApiResourceCopyWith<$Res> get type;

}
/// @nodoc
class __$PokemonTypeSlotApiModelCopyWithImpl<$Res>
    implements _$PokemonTypeSlotApiModelCopyWith<$Res> {
  __$PokemonTypeSlotApiModelCopyWithImpl(this._self, this._then);

  final _PokemonTypeSlotApiModel _self;
  final $Res Function(_PokemonTypeSlotApiModel) _then;

/// Create a copy of PokemonTypeSlotApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slot = null,Object? type = null,}) {
  return _then(_PokemonTypeSlotApiModel(
slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NamedApiResource,
  ));
}

/// Create a copy of PokemonTypeSlotApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedApiResourceCopyWith<$Res> get type {
  
  return $NamedApiResourceCopyWith<$Res>(_self.type, (value) {
    return _then(_self.copyWith(type: value));
  });
}
}


/// @nodoc
mixin _$PokemonStatApiModel {

 int get baseStat; int get effort; NamedApiResource get stat;
/// Create a copy of PokemonStatApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PokemonStatApiModelCopyWith<PokemonStatApiModel> get copyWith => _$PokemonStatApiModelCopyWithImpl<PokemonStatApiModel>(this as PokemonStatApiModel, _$identity);

  /// Serializes this PokemonStatApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PokemonStatApiModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PokemonStatApiModel&&(identical(other.baseStat, _this.baseStat) || other.baseStat == _this.baseStat)&&(identical(other.effort, _this.effort) || other.effort == _this.effort)&&(identical(other.stat, _this.stat) || other.stat == _this.stat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PokemonStatApiModel;
  return Object.hash(runtimeType,_this.baseStat,_this.effort,_this.stat);
}

@override
String toString() {
  final _this = this as PokemonStatApiModel;
  return 'PokemonStatApiModel(baseStat: ${_this.baseStat}, effort: ${_this.effort}, stat: ${_this.stat})';
}


}

/// @nodoc
abstract mixin class $PokemonStatApiModelCopyWith<$Res>  {
  factory $PokemonStatApiModelCopyWith(PokemonStatApiModel value, $Res Function(PokemonStatApiModel) _then) = _$PokemonStatApiModelCopyWithImpl;
@useResult
$Res call({
 int baseStat, int effort, NamedApiResource stat
});


$NamedApiResourceCopyWith<$Res> get stat;

}
/// @nodoc
class _$PokemonStatApiModelCopyWithImpl<$Res>
    implements $PokemonStatApiModelCopyWith<$Res> {
  _$PokemonStatApiModelCopyWithImpl(this._self, this._then);

  final PokemonStatApiModel _self;
  final $Res Function(PokemonStatApiModel) _then;

/// Create a copy of PokemonStatApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? baseStat = null,Object? effort = null,Object? stat = null,}) {
  return _then(PokemonStatApiModel(
baseStat: null == baseStat ? _self.baseStat : baseStat // ignore: cast_nullable_to_non_nullable
as int,effort: null == effort ? _self.effort : effort // ignore: cast_nullable_to_non_nullable
as int,stat: null == stat ? _self.stat : stat // ignore: cast_nullable_to_non_nullable
as NamedApiResource,
  ));
}
/// Create a copy of PokemonStatApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedApiResourceCopyWith<$Res> get stat {
  
  return $NamedApiResourceCopyWith<$Res>(_self.stat, (value) {
    return _then(_self.copyWith(stat: value));
  });
}
}


/// Adds pattern-matching-related methods to [PokemonStatApiModel].
extension PokemonStatApiModelPatterns on PokemonStatApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PokemonStatApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PokemonStatApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PokemonStatApiModel value)  $default,){
final _that = this;
switch (_that) {
case _PokemonStatApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PokemonStatApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _PokemonStatApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int baseStat,  int effort,  NamedApiResource stat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PokemonStatApiModel() when $default != null:
return $default(_that.baseStat,_that.effort,_that.stat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int baseStat,  int effort,  NamedApiResource stat)  $default,) {final _that = this;
switch (_that) {
case _PokemonStatApiModel():
return $default(_that.baseStat,_that.effort,_that.stat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int baseStat,  int effort,  NamedApiResource stat)?  $default,) {final _that = this;
switch (_that) {
case _PokemonStatApiModel() when $default != null:
return $default(_that.baseStat,_that.effort,_that.stat);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PokemonStatApiModel implements PokemonStatApiModel {
  const _PokemonStatApiModel({required this.baseStat, required this.effort, required this.stat});
  factory _PokemonStatApiModel.fromJson(Map<String, dynamic> json) => _$PokemonStatApiModelFromJson(json);

@override final  int baseStat;
@override final  int effort;
@override final  NamedApiResource stat;

/// Create a copy of PokemonStatApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PokemonStatApiModelCopyWith<_PokemonStatApiModel> get copyWith => __$PokemonStatApiModelCopyWithImpl<_PokemonStatApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PokemonStatApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PokemonStatApiModel&&(identical(other.baseStat, baseStat) || other.baseStat == baseStat)&&(identical(other.effort, effort) || other.effort == effort)&&(identical(other.stat, stat) || other.stat == stat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,baseStat,effort,stat);
}

@override
String toString() {
    return 'PokemonStatApiModel(baseStat: $baseStat, effort: $effort, stat: $stat)';
}


}

/// @nodoc
abstract mixin class _$PokemonStatApiModelCopyWith<$Res> implements $PokemonStatApiModelCopyWith<$Res> {
  factory _$PokemonStatApiModelCopyWith(_PokemonStatApiModel value, $Res Function(_PokemonStatApiModel) _then) = __$PokemonStatApiModelCopyWithImpl;
@override @useResult
$Res call({
 int baseStat, int effort, NamedApiResource stat
});


@override $NamedApiResourceCopyWith<$Res> get stat;

}
/// @nodoc
class __$PokemonStatApiModelCopyWithImpl<$Res>
    implements _$PokemonStatApiModelCopyWith<$Res> {
  __$PokemonStatApiModelCopyWithImpl(this._self, this._then);

  final _PokemonStatApiModel _self;
  final $Res Function(_PokemonStatApiModel) _then;

/// Create a copy of PokemonStatApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? baseStat = null,Object? effort = null,Object? stat = null,}) {
  return _then(_PokemonStatApiModel(
baseStat: null == baseStat ? _self.baseStat : baseStat // ignore: cast_nullable_to_non_nullable
as int,effort: null == effort ? _self.effort : effort // ignore: cast_nullable_to_non_nullable
as int,stat: null == stat ? _self.stat : stat // ignore: cast_nullable_to_non_nullable
as NamedApiResource,
  ));
}

/// Create a copy of PokemonStatApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedApiResourceCopyWith<$Res> get stat {
  
  return $NamedApiResourceCopyWith<$Res>(_self.stat, (value) {
    return _then(_self.copyWith(stat: value));
  });
}
}


/// @nodoc
mixin _$PokemonAbilityApiModel {

 NamedApiResource get ability; bool get isHidden; int get slot;
/// Create a copy of PokemonAbilityApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PokemonAbilityApiModelCopyWith<PokemonAbilityApiModel> get copyWith => _$PokemonAbilityApiModelCopyWithImpl<PokemonAbilityApiModel>(this as PokemonAbilityApiModel, _$identity);

  /// Serializes this PokemonAbilityApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PokemonAbilityApiModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PokemonAbilityApiModel&&(identical(other.ability, _this.ability) || other.ability == _this.ability)&&(identical(other.isHidden, _this.isHidden) || other.isHidden == _this.isHidden)&&(identical(other.slot, _this.slot) || other.slot == _this.slot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PokemonAbilityApiModel;
  return Object.hash(runtimeType,_this.ability,_this.isHidden,_this.slot);
}

@override
String toString() {
  final _this = this as PokemonAbilityApiModel;
  return 'PokemonAbilityApiModel(ability: ${_this.ability}, isHidden: ${_this.isHidden}, slot: ${_this.slot})';
}


}

/// @nodoc
abstract mixin class $PokemonAbilityApiModelCopyWith<$Res>  {
  factory $PokemonAbilityApiModelCopyWith(PokemonAbilityApiModel value, $Res Function(PokemonAbilityApiModel) _then) = _$PokemonAbilityApiModelCopyWithImpl;
@useResult
$Res call({
 NamedApiResource ability, bool isHidden, int slot
});


$NamedApiResourceCopyWith<$Res> get ability;

}
/// @nodoc
class _$PokemonAbilityApiModelCopyWithImpl<$Res>
    implements $PokemonAbilityApiModelCopyWith<$Res> {
  _$PokemonAbilityApiModelCopyWithImpl(this._self, this._then);

  final PokemonAbilityApiModel _self;
  final $Res Function(PokemonAbilityApiModel) _then;

/// Create a copy of PokemonAbilityApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ability = null,Object? isHidden = null,Object? slot = null,}) {
  return _then(PokemonAbilityApiModel(
ability: null == ability ? _self.ability : ability // ignore: cast_nullable_to_non_nullable
as NamedApiResource,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PokemonAbilityApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedApiResourceCopyWith<$Res> get ability {
  
  return $NamedApiResourceCopyWith<$Res>(_self.ability, (value) {
    return _then(_self.copyWith(ability: value));
  });
}
}


/// Adds pattern-matching-related methods to [PokemonAbilityApiModel].
extension PokemonAbilityApiModelPatterns on PokemonAbilityApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PokemonAbilityApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PokemonAbilityApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PokemonAbilityApiModel value)  $default,){
final _that = this;
switch (_that) {
case _PokemonAbilityApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PokemonAbilityApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _PokemonAbilityApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NamedApiResource ability,  bool isHidden,  int slot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PokemonAbilityApiModel() when $default != null:
return $default(_that.ability,_that.isHidden,_that.slot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NamedApiResource ability,  bool isHidden,  int slot)  $default,) {final _that = this;
switch (_that) {
case _PokemonAbilityApiModel():
return $default(_that.ability,_that.isHidden,_that.slot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NamedApiResource ability,  bool isHidden,  int slot)?  $default,) {final _that = this;
switch (_that) {
case _PokemonAbilityApiModel() when $default != null:
return $default(_that.ability,_that.isHidden,_that.slot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PokemonAbilityApiModel implements PokemonAbilityApiModel {
  const _PokemonAbilityApiModel({required this.ability, required this.isHidden, required this.slot});
  factory _PokemonAbilityApiModel.fromJson(Map<String, dynamic> json) => _$PokemonAbilityApiModelFromJson(json);

@override final  NamedApiResource ability;
@override final  bool isHidden;
@override final  int slot;

/// Create a copy of PokemonAbilityApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PokemonAbilityApiModelCopyWith<_PokemonAbilityApiModel> get copyWith => __$PokemonAbilityApiModelCopyWithImpl<_PokemonAbilityApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PokemonAbilityApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PokemonAbilityApiModel&&(identical(other.ability, ability) || other.ability == ability)&&(identical(other.isHidden, isHidden) || other.isHidden == isHidden)&&(identical(other.slot, slot) || other.slot == slot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ability,isHidden,slot);
}

@override
String toString() {
    return 'PokemonAbilityApiModel(ability: $ability, isHidden: $isHidden, slot: $slot)';
}


}

/// @nodoc
abstract mixin class _$PokemonAbilityApiModelCopyWith<$Res> implements $PokemonAbilityApiModelCopyWith<$Res> {
  factory _$PokemonAbilityApiModelCopyWith(_PokemonAbilityApiModel value, $Res Function(_PokemonAbilityApiModel) _then) = __$PokemonAbilityApiModelCopyWithImpl;
@override @useResult
$Res call({
 NamedApiResource ability, bool isHidden, int slot
});


@override $NamedApiResourceCopyWith<$Res> get ability;

}
/// @nodoc
class __$PokemonAbilityApiModelCopyWithImpl<$Res>
    implements _$PokemonAbilityApiModelCopyWith<$Res> {
  __$PokemonAbilityApiModelCopyWithImpl(this._self, this._then);

  final _PokemonAbilityApiModel _self;
  final $Res Function(_PokemonAbilityApiModel) _then;

/// Create a copy of PokemonAbilityApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ability = null,Object? isHidden = null,Object? slot = null,}) {
  return _then(_PokemonAbilityApiModel(
ability: null == ability ? _self.ability : ability // ignore: cast_nullable_to_non_nullable
as NamedApiResource,isHidden: null == isHidden ? _self.isHidden : isHidden // ignore: cast_nullable_to_non_nullable
as bool,slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PokemonAbilityApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NamedApiResourceCopyWith<$Res> get ability {
  
  return $NamedApiResourceCopyWith<$Res>(_self.ability, (value) {
    return _then(_self.copyWith(ability: value));
  });
}
}


/// @nodoc
mixin _$PokemonSpritesApiModel {

 String get frontDefault; OtherSpritesApiModel? get other;
/// Create a copy of PokemonSpritesApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PokemonSpritesApiModelCopyWith<PokemonSpritesApiModel> get copyWith => _$PokemonSpritesApiModelCopyWithImpl<PokemonSpritesApiModel>(this as PokemonSpritesApiModel, _$identity);

  /// Serializes this PokemonSpritesApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PokemonSpritesApiModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PokemonSpritesApiModel&&(identical(other.frontDefault, _this.frontDefault) || other.frontDefault == _this.frontDefault)&&(identical(other.other, _this.other) || other.other == _this.other));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PokemonSpritesApiModel;
  return Object.hash(runtimeType,_this.frontDefault,_this.other);
}

@override
String toString() {
  final _this = this as PokemonSpritesApiModel;
  return 'PokemonSpritesApiModel(frontDefault: ${_this.frontDefault}, other: ${_this.other})';
}


}

/// @nodoc
abstract mixin class $PokemonSpritesApiModelCopyWith<$Res>  {
  factory $PokemonSpritesApiModelCopyWith(PokemonSpritesApiModel value, $Res Function(PokemonSpritesApiModel) _then) = _$PokemonSpritesApiModelCopyWithImpl;
@useResult
$Res call({
 String frontDefault, OtherSpritesApiModel? other
});


$OtherSpritesApiModelCopyWith<$Res>? get other;

}
/// @nodoc
class _$PokemonSpritesApiModelCopyWithImpl<$Res>
    implements $PokemonSpritesApiModelCopyWith<$Res> {
  _$PokemonSpritesApiModelCopyWithImpl(this._self, this._then);

  final PokemonSpritesApiModel _self;
  final $Res Function(PokemonSpritesApiModel) _then;

/// Create a copy of PokemonSpritesApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? frontDefault = null,Object? other = freezed,}) {
  return _then(PokemonSpritesApiModel(
frontDefault: null == frontDefault ? _self.frontDefault : frontDefault // ignore: cast_nullable_to_non_nullable
as String,other: freezed == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as OtherSpritesApiModel?,
  ));
}
/// Create a copy of PokemonSpritesApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OtherSpritesApiModelCopyWith<$Res>? get other {
    if (_self.other == null) {
    return null;
  }

  return $OtherSpritesApiModelCopyWith<$Res>(_self.other!, (value) {
    return _then(_self.copyWith(other: value));
  });
}
}


/// Adds pattern-matching-related methods to [PokemonSpritesApiModel].
extension PokemonSpritesApiModelPatterns on PokemonSpritesApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PokemonSpritesApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PokemonSpritesApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PokemonSpritesApiModel value)  $default,){
final _that = this;
switch (_that) {
case _PokemonSpritesApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PokemonSpritesApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _PokemonSpritesApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String frontDefault,  OtherSpritesApiModel? other)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PokemonSpritesApiModel() when $default != null:
return $default(_that.frontDefault,_that.other);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String frontDefault,  OtherSpritesApiModel? other)  $default,) {final _that = this;
switch (_that) {
case _PokemonSpritesApiModel():
return $default(_that.frontDefault,_that.other);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String frontDefault,  OtherSpritesApiModel? other)?  $default,) {final _that = this;
switch (_that) {
case _PokemonSpritesApiModel() when $default != null:
return $default(_that.frontDefault,_that.other);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PokemonSpritesApiModel implements PokemonSpritesApiModel {
  const _PokemonSpritesApiModel({required this.frontDefault, this.other});
  factory _PokemonSpritesApiModel.fromJson(Map<String, dynamic> json) => _$PokemonSpritesApiModelFromJson(json);

@override final  String frontDefault;
@override final  OtherSpritesApiModel? other;

/// Create a copy of PokemonSpritesApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PokemonSpritesApiModelCopyWith<_PokemonSpritesApiModel> get copyWith => __$PokemonSpritesApiModelCopyWithImpl<_PokemonSpritesApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PokemonSpritesApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PokemonSpritesApiModel&&(identical(other.frontDefault, frontDefault) || other.frontDefault == frontDefault)&&(identical(other.other, this.other) || other.other == this.other));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,frontDefault,other);
}

@override
String toString() {
    return 'PokemonSpritesApiModel(frontDefault: $frontDefault, other: $other)';
}


}

/// @nodoc
abstract mixin class _$PokemonSpritesApiModelCopyWith<$Res> implements $PokemonSpritesApiModelCopyWith<$Res> {
  factory _$PokemonSpritesApiModelCopyWith(_PokemonSpritesApiModel value, $Res Function(_PokemonSpritesApiModel) _then) = __$PokemonSpritesApiModelCopyWithImpl;
@override @useResult
$Res call({
 String frontDefault, OtherSpritesApiModel? other
});


@override $OtherSpritesApiModelCopyWith<$Res>? get other;

}
/// @nodoc
class __$PokemonSpritesApiModelCopyWithImpl<$Res>
    implements _$PokemonSpritesApiModelCopyWith<$Res> {
  __$PokemonSpritesApiModelCopyWithImpl(this._self, this._then);

  final _PokemonSpritesApiModel _self;
  final $Res Function(_PokemonSpritesApiModel) _then;

/// Create a copy of PokemonSpritesApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? frontDefault = null,Object? other = freezed,}) {
  return _then(_PokemonSpritesApiModel(
frontDefault: null == frontDefault ? _self.frontDefault : frontDefault // ignore: cast_nullable_to_non_nullable
as String,other: freezed == other ? _self.other : other // ignore: cast_nullable_to_non_nullable
as OtherSpritesApiModel?,
  ));
}

/// Create a copy of PokemonSpritesApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OtherSpritesApiModelCopyWith<$Res>? get other {
    if (_self.other == null) {
    return null;
  }

  return $OtherSpritesApiModelCopyWith<$Res>(_self.other!, (value) {
    return _then(_self.copyWith(other: value));
  });
}
}


/// @nodoc
mixin _$OtherSpritesApiModel {

@JsonKey(name: 'official-artwork') OfficialArtworkApiModel? get officialArtwork;
/// Create a copy of OtherSpritesApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtherSpritesApiModelCopyWith<OtherSpritesApiModel> get copyWith => _$OtherSpritesApiModelCopyWithImpl<OtherSpritesApiModel>(this as OtherSpritesApiModel, _$identity);

  /// Serializes this OtherSpritesApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OtherSpritesApiModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtherSpritesApiModel&&(identical(other.officialArtwork, _this.officialArtwork) || other.officialArtwork == _this.officialArtwork));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OtherSpritesApiModel;
  return Object.hash(runtimeType,_this.officialArtwork);
}

@override
String toString() {
  final _this = this as OtherSpritesApiModel;
  return 'OtherSpritesApiModel(officialArtwork: ${_this.officialArtwork})';
}


}

/// @nodoc
abstract mixin class $OtherSpritesApiModelCopyWith<$Res>  {
  factory $OtherSpritesApiModelCopyWith(OtherSpritesApiModel value, $Res Function(OtherSpritesApiModel) _then) = _$OtherSpritesApiModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'official-artwork') OfficialArtworkApiModel? officialArtwork
});


$OfficialArtworkApiModelCopyWith<$Res>? get officialArtwork;

}
/// @nodoc
class _$OtherSpritesApiModelCopyWithImpl<$Res>
    implements $OtherSpritesApiModelCopyWith<$Res> {
  _$OtherSpritesApiModelCopyWithImpl(this._self, this._then);

  final OtherSpritesApiModel _self;
  final $Res Function(OtherSpritesApiModel) _then;

/// Create a copy of OtherSpritesApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? officialArtwork = freezed,}) {
  return _then(OtherSpritesApiModel(
officialArtwork: freezed == officialArtwork ? _self.officialArtwork : officialArtwork // ignore: cast_nullable_to_non_nullable
as OfficialArtworkApiModel?,
  ));
}
/// Create a copy of OtherSpritesApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfficialArtworkApiModelCopyWith<$Res>? get officialArtwork {
    if (_self.officialArtwork == null) {
    return null;
  }

  return $OfficialArtworkApiModelCopyWith<$Res>(_self.officialArtwork!, (value) {
    return _then(_self.copyWith(officialArtwork: value));
  });
}
}


/// Adds pattern-matching-related methods to [OtherSpritesApiModel].
extension OtherSpritesApiModelPatterns on OtherSpritesApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtherSpritesApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtherSpritesApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtherSpritesApiModel value)  $default,){
final _that = this;
switch (_that) {
case _OtherSpritesApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtherSpritesApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _OtherSpritesApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'official-artwork')  OfficialArtworkApiModel? officialArtwork)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtherSpritesApiModel() when $default != null:
return $default(_that.officialArtwork);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'official-artwork')  OfficialArtworkApiModel? officialArtwork)  $default,) {final _that = this;
switch (_that) {
case _OtherSpritesApiModel():
return $default(_that.officialArtwork);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'official-artwork')  OfficialArtworkApiModel? officialArtwork)?  $default,) {final _that = this;
switch (_that) {
case _OtherSpritesApiModel() when $default != null:
return $default(_that.officialArtwork);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OtherSpritesApiModel implements OtherSpritesApiModel {
  const _OtherSpritesApiModel({@JsonKey(name: 'official-artwork') this.officialArtwork});
  factory _OtherSpritesApiModel.fromJson(Map<String, dynamic> json) => _$OtherSpritesApiModelFromJson(json);

@override@JsonKey(name: 'official-artwork') final  OfficialArtworkApiModel? officialArtwork;

/// Create a copy of OtherSpritesApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtherSpritesApiModelCopyWith<_OtherSpritesApiModel> get copyWith => __$OtherSpritesApiModelCopyWithImpl<_OtherSpritesApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OtherSpritesApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtherSpritesApiModel&&(identical(other.officialArtwork, officialArtwork) || other.officialArtwork == officialArtwork));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,officialArtwork);
}

@override
String toString() {
    return 'OtherSpritesApiModel(officialArtwork: $officialArtwork)';
}


}

/// @nodoc
abstract mixin class _$OtherSpritesApiModelCopyWith<$Res> implements $OtherSpritesApiModelCopyWith<$Res> {
  factory _$OtherSpritesApiModelCopyWith(_OtherSpritesApiModel value, $Res Function(_OtherSpritesApiModel) _then) = __$OtherSpritesApiModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'official-artwork') OfficialArtworkApiModel? officialArtwork
});


@override $OfficialArtworkApiModelCopyWith<$Res>? get officialArtwork;

}
/// @nodoc
class __$OtherSpritesApiModelCopyWithImpl<$Res>
    implements _$OtherSpritesApiModelCopyWith<$Res> {
  __$OtherSpritesApiModelCopyWithImpl(this._self, this._then);

  final _OtherSpritesApiModel _self;
  final $Res Function(_OtherSpritesApiModel) _then;

/// Create a copy of OtherSpritesApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? officialArtwork = freezed,}) {
  return _then(_OtherSpritesApiModel(
officialArtwork: freezed == officialArtwork ? _self.officialArtwork : officialArtwork // ignore: cast_nullable_to_non_nullable
as OfficialArtworkApiModel?,
  ));
}

/// Create a copy of OtherSpritesApiModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfficialArtworkApiModelCopyWith<$Res>? get officialArtwork {
    if (_self.officialArtwork == null) {
    return null;
  }

  return $OfficialArtworkApiModelCopyWith<$Res>(_self.officialArtwork!, (value) {
    return _then(_self.copyWith(officialArtwork: value));
  });
}
}


/// @nodoc
mixin _$OfficialArtworkApiModel {

 String get frontDefault;
/// Create a copy of OfficialArtworkApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfficialArtworkApiModelCopyWith<OfficialArtworkApiModel> get copyWith => _$OfficialArtworkApiModelCopyWithImpl<OfficialArtworkApiModel>(this as OfficialArtworkApiModel, _$identity);

  /// Serializes this OfficialArtworkApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OfficialArtworkApiModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfficialArtworkApiModel&&(identical(other.frontDefault, _this.frontDefault) || other.frontDefault == _this.frontDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OfficialArtworkApiModel;
  return Object.hash(runtimeType,_this.frontDefault);
}

@override
String toString() {
  final _this = this as OfficialArtworkApiModel;
  return 'OfficialArtworkApiModel(frontDefault: ${_this.frontDefault})';
}


}

/// @nodoc
abstract mixin class $OfficialArtworkApiModelCopyWith<$Res>  {
  factory $OfficialArtworkApiModelCopyWith(OfficialArtworkApiModel value, $Res Function(OfficialArtworkApiModel) _then) = _$OfficialArtworkApiModelCopyWithImpl;
@useResult
$Res call({
 String frontDefault
});




}
/// @nodoc
class _$OfficialArtworkApiModelCopyWithImpl<$Res>
    implements $OfficialArtworkApiModelCopyWith<$Res> {
  _$OfficialArtworkApiModelCopyWithImpl(this._self, this._then);

  final OfficialArtworkApiModel _self;
  final $Res Function(OfficialArtworkApiModel) _then;

/// Create a copy of OfficialArtworkApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? frontDefault = null,}) {
  return _then(OfficialArtworkApiModel(
frontDefault: null == frontDefault ? _self.frontDefault : frontDefault // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OfficialArtworkApiModel].
extension OfficialArtworkApiModelPatterns on OfficialArtworkApiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfficialArtworkApiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfficialArtworkApiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfficialArtworkApiModel value)  $default,){
final _that = this;
switch (_that) {
case _OfficialArtworkApiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfficialArtworkApiModel value)?  $default,){
final _that = this;
switch (_that) {
case _OfficialArtworkApiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String frontDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfficialArtworkApiModel() when $default != null:
return $default(_that.frontDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String frontDefault)  $default,) {final _that = this;
switch (_that) {
case _OfficialArtworkApiModel():
return $default(_that.frontDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String frontDefault)?  $default,) {final _that = this;
switch (_that) {
case _OfficialArtworkApiModel() when $default != null:
return $default(_that.frontDefault);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfficialArtworkApiModel implements OfficialArtworkApiModel {
  const _OfficialArtworkApiModel({required this.frontDefault});
  factory _OfficialArtworkApiModel.fromJson(Map<String, dynamic> json) => _$OfficialArtworkApiModelFromJson(json);

@override final  String frontDefault;

/// Create a copy of OfficialArtworkApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfficialArtworkApiModelCopyWith<_OfficialArtworkApiModel> get copyWith => __$OfficialArtworkApiModelCopyWithImpl<_OfficialArtworkApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfficialArtworkApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfficialArtworkApiModel&&(identical(other.frontDefault, frontDefault) || other.frontDefault == frontDefault));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,frontDefault);
}

@override
String toString() {
    return 'OfficialArtworkApiModel(frontDefault: $frontDefault)';
}


}

/// @nodoc
abstract mixin class _$OfficialArtworkApiModelCopyWith<$Res> implements $OfficialArtworkApiModelCopyWith<$Res> {
  factory _$OfficialArtworkApiModelCopyWith(_OfficialArtworkApiModel value, $Res Function(_OfficialArtworkApiModel) _then) = __$OfficialArtworkApiModelCopyWithImpl;
@override @useResult
$Res call({
 String frontDefault
});




}
/// @nodoc
class __$OfficialArtworkApiModelCopyWithImpl<$Res>
    implements _$OfficialArtworkApiModelCopyWith<$Res> {
  __$OfficialArtworkApiModelCopyWithImpl(this._self, this._then);

  final _OfficialArtworkApiModel _self;
  final $Res Function(_OfficialArtworkApiModel) _then;

/// Create a copy of OfficialArtworkApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? frontDefault = null,}) {
  return _then(_OfficialArtworkApiModel(
frontDefault: null == frontDefault ? _self.frontDefault : frontDefault // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
