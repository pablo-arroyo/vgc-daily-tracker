// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pokemon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Pokemon {

 int get id;/// PokéAPI identifier, e.g. `raichu-mega-y`.
 String get slug;/// The species it belongs to, e.g. `raichu` for `raichu-mega-y`. Two
/// forms of one species can't share a team (the VGC species clause).
 String get speciesSlug;/// Human-readable name, e.g. `Raichu-Mega-Y`.
 String get displayName;/// Type names in slot order, e.g. `['dark', 'steel']`.
 List<String> get types; BaseStats get baseStats; String get spriteUrl;/// Ability slugs, hidden ability last, e.g. `['defiant', ...]`.
 List<String> get abilities;
/// Create a copy of Pokemon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PokemonCopyWith<Pokemon> get copyWith => _$PokemonCopyWithImpl<Pokemon>(this as Pokemon, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Pokemon;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pokemon&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.speciesSlug, _this.speciesSlug) || other.speciesSlug == _this.speciesSlug)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&const DeepCollectionEquality().equals(other.types, _this.types)&&(identical(other.baseStats, _this.baseStats) || other.baseStats == _this.baseStats)&&(identical(other.spriteUrl, _this.spriteUrl) || other.spriteUrl == _this.spriteUrl)&&const DeepCollectionEquality().equals(other.abilities, _this.abilities));
}


@override
int get hashCode {
  final _this = this as Pokemon;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.speciesSlug,_this.displayName,const DeepCollectionEquality().hash(_this.types),_this.baseStats,_this.spriteUrl,const DeepCollectionEquality().hash(_this.abilities));
}

@override
String toString() {
  final _this = this as Pokemon;
  return 'Pokemon(id: ${_this.id}, slug: ${_this.slug}, speciesSlug: ${_this.speciesSlug}, displayName: ${_this.displayName}, types: ${_this.types}, baseStats: ${_this.baseStats}, spriteUrl: ${_this.spriteUrl}, abilities: ${_this.abilities})';
}


}

/// @nodoc
abstract mixin class $PokemonCopyWith<$Res>  {
  factory $PokemonCopyWith(Pokemon value, $Res Function(Pokemon) _then) = _$PokemonCopyWithImpl;
@useResult
$Res call({
 int id, String slug, String speciesSlug, String displayName, List<String> types, BaseStats baseStats, String spriteUrl, List<String> abilities
});


$BaseStatsCopyWith<$Res> get baseStats;

}
/// @nodoc
class _$PokemonCopyWithImpl<$Res>
    implements $PokemonCopyWith<$Res> {
  _$PokemonCopyWithImpl(this._self, this._then);

  final Pokemon _self;
  final $Res Function(Pokemon) _then;

/// Create a copy of Pokemon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? speciesSlug = null,Object? displayName = null,Object? types = null,Object? baseStats = null,Object? spriteUrl = null,Object? abilities = null,}) {
  return _then(Pokemon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,speciesSlug: null == speciesSlug ? _self.speciesSlug : speciesSlug // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,types: null == types ? _self.types : types // ignore: cast_nullable_to_non_nullable
as List<String>,baseStats: null == baseStats ? _self.baseStats : baseStats // ignore: cast_nullable_to_non_nullable
as BaseStats,spriteUrl: null == spriteUrl ? _self.spriteUrl : spriteUrl // ignore: cast_nullable_to_non_nullable
as String,abilities: null == abilities ? _self.abilities : abilities // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of Pokemon
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BaseStatsCopyWith<$Res> get baseStats {
  
  return $BaseStatsCopyWith<$Res>(_self.baseStats, (value) {
    return _then(_self.copyWith(baseStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [Pokemon].
extension PokemonPatterns on Pokemon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pokemon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pokemon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pokemon value)  $default,){
final _that = this;
switch (_that) {
case _Pokemon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pokemon value)?  $default,){
final _that = this;
switch (_that) {
case _Pokemon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String slug,  String speciesSlug,  String displayName,  List<String> types,  BaseStats baseStats,  String spriteUrl,  List<String> abilities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pokemon() when $default != null:
return $default(_that.id,_that.slug,_that.speciesSlug,_that.displayName,_that.types,_that.baseStats,_that.spriteUrl,_that.abilities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String slug,  String speciesSlug,  String displayName,  List<String> types,  BaseStats baseStats,  String spriteUrl,  List<String> abilities)  $default,) {final _that = this;
switch (_that) {
case _Pokemon():
return $default(_that.id,_that.slug,_that.speciesSlug,_that.displayName,_that.types,_that.baseStats,_that.spriteUrl,_that.abilities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String slug,  String speciesSlug,  String displayName,  List<String> types,  BaseStats baseStats,  String spriteUrl,  List<String> abilities)?  $default,) {final _that = this;
switch (_that) {
case _Pokemon() when $default != null:
return $default(_that.id,_that.slug,_that.speciesSlug,_that.displayName,_that.types,_that.baseStats,_that.spriteUrl,_that.abilities);case _:
  return null;

}
}

}

/// @nodoc


class _Pokemon implements Pokemon {
  const _Pokemon({required this.id, required this.slug, required this.speciesSlug, required this.displayName, required  List<String> types, required this.baseStats, required this.spriteUrl,  List<String> abilities = const []}): _types = types,_abilities = abilities;
  

@override final  int id;
/// PokéAPI identifier, e.g. `raichu-mega-y`.
@override final  String slug;
/// The species it belongs to, e.g. `raichu` for `raichu-mega-y`. Two
/// forms of one species can't share a team (the VGC species clause).
@override final  String speciesSlug;
/// Human-readable name, e.g. `Raichu-Mega-Y`.
@override final  String displayName;
/// Type names in slot order, e.g. `['dark', 'steel']`.
 final  List<String> _types;
/// Type names in slot order, e.g. `['dark', 'steel']`.
@override List<String> get types {
  if (_types is EqualUnmodifiableListView) return _types;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_types);
}

@override final  BaseStats baseStats;
@override final  String spriteUrl;
/// Ability slugs, hidden ability last, e.g. `['defiant', ...]`.
 final  List<String> _abilities;
/// Ability slugs, hidden ability last, e.g. `['defiant', ...]`.
@override@JsonKey() List<String> get abilities {
  if (_abilities is EqualUnmodifiableListView) return _abilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_abilities);
}


/// Create a copy of Pokemon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PokemonCopyWith<_Pokemon> get copyWith => __$PokemonCopyWithImpl<_Pokemon>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pokemon&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.speciesSlug, speciesSlug) || other.speciesSlug == speciesSlug)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&const DeepCollectionEquality().equals(other.types, _types)&&(identical(other.baseStats, baseStats) || other.baseStats == baseStats)&&(identical(other.spriteUrl, spriteUrl) || other.spriteUrl == spriteUrl)&&const DeepCollectionEquality().equals(other.abilities, _abilities));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,speciesSlug,displayName,const DeepCollectionEquality().hash(_types),baseStats,spriteUrl,const DeepCollectionEquality().hash(_abilities));
}

@override
String toString() {
    return 'Pokemon(id: $id, slug: $slug, speciesSlug: $speciesSlug, displayName: $displayName, types: $types, baseStats: $baseStats, spriteUrl: $spriteUrl, abilities: $abilities)';
}


}

/// @nodoc
abstract mixin class _$PokemonCopyWith<$Res> implements $PokemonCopyWith<$Res> {
  factory _$PokemonCopyWith(_Pokemon value, $Res Function(_Pokemon) _then) = __$PokemonCopyWithImpl;
@override @useResult
$Res call({
 int id, String slug, String speciesSlug, String displayName, List<String> types, BaseStats baseStats, String spriteUrl, List<String> abilities
});


@override $BaseStatsCopyWith<$Res> get baseStats;

}
/// @nodoc
class __$PokemonCopyWithImpl<$Res>
    implements _$PokemonCopyWith<$Res> {
  __$PokemonCopyWithImpl(this._self, this._then);

  final _Pokemon _self;
  final $Res Function(_Pokemon) _then;

/// Create a copy of Pokemon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? speciesSlug = null,Object? displayName = null,Object? types = null,Object? baseStats = null,Object? spriteUrl = null,Object? abilities = null,}) {
  return _then(_Pokemon(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,speciesSlug: null == speciesSlug ? _self.speciesSlug : speciesSlug // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,types: null == types ? _self._types : types // ignore: cast_nullable_to_non_nullable
as List<String>,baseStats: null == baseStats ? _self.baseStats : baseStats // ignore: cast_nullable_to_non_nullable
as BaseStats,spriteUrl: null == spriteUrl ? _self.spriteUrl : spriteUrl // ignore: cast_nullable_to_non_nullable
as String,abilities: null == abilities ? _self._abilities : abilities // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of Pokemon
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BaseStatsCopyWith<$Res> get baseStats {
  
  return $BaseStatsCopyWith<$Res>(_self.baseStats, (value) {
    return _then(_self.copyWith(baseStats: value));
  });
}
}

/// @nodoc
mixin _$BaseStats {

 int get hp; int get attack; int get defense; int get specialAttack; int get specialDefense; int get speed;
/// Create a copy of BaseStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BaseStatsCopyWith<BaseStats> get copyWith => _$BaseStatsCopyWithImpl<BaseStats>(this as BaseStats, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BaseStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BaseStats&&(identical(other.hp, _this.hp) || other.hp == _this.hp)&&(identical(other.attack, _this.attack) || other.attack == _this.attack)&&(identical(other.defense, _this.defense) || other.defense == _this.defense)&&(identical(other.specialAttack, _this.specialAttack) || other.specialAttack == _this.specialAttack)&&(identical(other.specialDefense, _this.specialDefense) || other.specialDefense == _this.specialDefense)&&(identical(other.speed, _this.speed) || other.speed == _this.speed));
}


@override
int get hashCode {
  final _this = this as BaseStats;
  return Object.hash(runtimeType,_this.hp,_this.attack,_this.defense,_this.specialAttack,_this.specialDefense,_this.speed);
}

@override
String toString() {
  final _this = this as BaseStats;
  return 'BaseStats(hp: ${_this.hp}, attack: ${_this.attack}, defense: ${_this.defense}, specialAttack: ${_this.specialAttack}, specialDefense: ${_this.specialDefense}, speed: ${_this.speed})';
}


}

/// @nodoc
abstract mixin class $BaseStatsCopyWith<$Res>  {
  factory $BaseStatsCopyWith(BaseStats value, $Res Function(BaseStats) _then) = _$BaseStatsCopyWithImpl;
@useResult
$Res call({
 int hp, int attack, int defense, int specialAttack, int specialDefense, int speed
});




}
/// @nodoc
class _$BaseStatsCopyWithImpl<$Res>
    implements $BaseStatsCopyWith<$Res> {
  _$BaseStatsCopyWithImpl(this._self, this._then);

  final BaseStats _self;
  final $Res Function(BaseStats) _then;

/// Create a copy of BaseStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hp = null,Object? attack = null,Object? defense = null,Object? specialAttack = null,Object? specialDefense = null,Object? speed = null,}) {
  return _then(BaseStats(
hp: null == hp ? _self.hp : hp // ignore: cast_nullable_to_non_nullable
as int,attack: null == attack ? _self.attack : attack // ignore: cast_nullable_to_non_nullable
as int,defense: null == defense ? _self.defense : defense // ignore: cast_nullable_to_non_nullable
as int,specialAttack: null == specialAttack ? _self.specialAttack : specialAttack // ignore: cast_nullable_to_non_nullable
as int,specialDefense: null == specialDefense ? _self.specialDefense : specialDefense // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BaseStats].
extension BaseStatsPatterns on BaseStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BaseStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BaseStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BaseStats value)  $default,){
final _that = this;
switch (_that) {
case _BaseStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BaseStats value)?  $default,){
final _that = this;
switch (_that) {
case _BaseStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hp,  int attack,  int defense,  int specialAttack,  int specialDefense,  int speed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BaseStats() when $default != null:
return $default(_that.hp,_that.attack,_that.defense,_that.specialAttack,_that.specialDefense,_that.speed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hp,  int attack,  int defense,  int specialAttack,  int specialDefense,  int speed)  $default,) {final _that = this;
switch (_that) {
case _BaseStats():
return $default(_that.hp,_that.attack,_that.defense,_that.specialAttack,_that.specialDefense,_that.speed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hp,  int attack,  int defense,  int specialAttack,  int specialDefense,  int speed)?  $default,) {final _that = this;
switch (_that) {
case _BaseStats() when $default != null:
return $default(_that.hp,_that.attack,_that.defense,_that.specialAttack,_that.specialDefense,_that.speed);case _:
  return null;

}
}

}

/// @nodoc


class _BaseStats extends BaseStats {
  const _BaseStats({required this.hp, required this.attack, required this.defense, required this.specialAttack, required this.specialDefense, required this.speed}): super._();
  

@override final  int hp;
@override final  int attack;
@override final  int defense;
@override final  int specialAttack;
@override final  int specialDefense;
@override final  int speed;

/// Create a copy of BaseStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BaseStatsCopyWith<_BaseStats> get copyWith => __$BaseStatsCopyWithImpl<_BaseStats>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BaseStats&&(identical(other.hp, hp) || other.hp == hp)&&(identical(other.attack, attack) || other.attack == attack)&&(identical(other.defense, defense) || other.defense == defense)&&(identical(other.specialAttack, specialAttack) || other.specialAttack == specialAttack)&&(identical(other.specialDefense, specialDefense) || other.specialDefense == specialDefense)&&(identical(other.speed, speed) || other.speed == speed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hp,attack,defense,specialAttack,specialDefense,speed);
}

@override
String toString() {
    return 'BaseStats(hp: $hp, attack: $attack, defense: $defense, specialAttack: $specialAttack, specialDefense: $specialDefense, speed: $speed)';
}


}

/// @nodoc
abstract mixin class _$BaseStatsCopyWith<$Res> implements $BaseStatsCopyWith<$Res> {
  factory _$BaseStatsCopyWith(_BaseStats value, $Res Function(_BaseStats) _then) = __$BaseStatsCopyWithImpl;
@override @useResult
$Res call({
 int hp, int attack, int defense, int specialAttack, int specialDefense, int speed
});




}
/// @nodoc
class __$BaseStatsCopyWithImpl<$Res>
    implements _$BaseStatsCopyWith<$Res> {
  __$BaseStatsCopyWithImpl(this._self, this._then);

  final _BaseStats _self;
  final $Res Function(_BaseStats) _then;

/// Create a copy of BaseStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hp = null,Object? attack = null,Object? defense = null,Object? specialAttack = null,Object? specialDefense = null,Object? speed = null,}) {
  return _then(_BaseStats(
hp: null == hp ? _self.hp : hp // ignore: cast_nullable_to_non_nullable
as int,attack: null == attack ? _self.attack : attack // ignore: cast_nullable_to_non_nullable
as int,defense: null == defense ? _self.defense : defense // ignore: cast_nullable_to_non_nullable
as int,specialAttack: null == specialAttack ? _self.specialAttack : specialAttack // ignore: cast_nullable_to_non_nullable
as int,specialDefense: null == specialDefense ? _self.specialDefense : specialDefense // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
