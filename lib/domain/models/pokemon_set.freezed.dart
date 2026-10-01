// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pokemon_set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PokemonSet {

 String get species; String? get nickname;/// `M` or `F`, when the paste gives one.
 String? get gender; String? get item; String? get ability;/// The ability after Mega Evolving, from the artifact's `A → B`.
 String? get megaAbility;/// VGC plays at level 50, so that's the default.
 int get level; StatSpread get evs; StatSpread get ivs;/// Showdown's choice when a paste names no nature.
 Nature get nature; List<String> get moves;
/// Create a copy of PokemonSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PokemonSetCopyWith<PokemonSet> get copyWith => _$PokemonSetCopyWithImpl<PokemonSet>(this as PokemonSet, _$identity);

  /// Serializes this PokemonSet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PokemonSet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PokemonSet&&(identical(other.species, _this.species) || other.species == _this.species)&&(identical(other.nickname, _this.nickname) || other.nickname == _this.nickname)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.item, _this.item) || other.item == _this.item)&&(identical(other.ability, _this.ability) || other.ability == _this.ability)&&(identical(other.megaAbility, _this.megaAbility) || other.megaAbility == _this.megaAbility)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.evs, _this.evs) || other.evs == _this.evs)&&(identical(other.ivs, _this.ivs) || other.ivs == _this.ivs)&&(identical(other.nature, _this.nature) || other.nature == _this.nature)&&const DeepCollectionEquality().equals(other.moves, _this.moves));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PokemonSet;
  return Object.hash(runtimeType,_this.species,_this.nickname,_this.gender,_this.item,_this.ability,_this.megaAbility,_this.level,_this.evs,_this.ivs,_this.nature,const DeepCollectionEquality().hash(_this.moves));
}

@override
String toString() {
  final _this = this as PokemonSet;
  return 'PokemonSet(species: ${_this.species}, nickname: ${_this.nickname}, gender: ${_this.gender}, item: ${_this.item}, ability: ${_this.ability}, megaAbility: ${_this.megaAbility}, level: ${_this.level}, evs: ${_this.evs}, ivs: ${_this.ivs}, nature: ${_this.nature}, moves: ${_this.moves})';
}


}

/// @nodoc
abstract mixin class $PokemonSetCopyWith<$Res>  {
  factory $PokemonSetCopyWith(PokemonSet value, $Res Function(PokemonSet) _then) = _$PokemonSetCopyWithImpl;
@useResult
$Res call({
 String species, String? nickname, String? gender, String? item, String? ability, String? megaAbility, int level, StatSpread evs, StatSpread ivs, Nature nature, List<String> moves
});


$StatSpreadCopyWith<$Res> get evs;$StatSpreadCopyWith<$Res> get ivs;

}
/// @nodoc
class _$PokemonSetCopyWithImpl<$Res>
    implements $PokemonSetCopyWith<$Res> {
  _$PokemonSetCopyWithImpl(this._self, this._then);

  final PokemonSet _self;
  final $Res Function(PokemonSet) _then;

/// Create a copy of PokemonSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? species = null,Object? nickname = freezed,Object? gender = freezed,Object? item = freezed,Object? ability = freezed,Object? megaAbility = freezed,Object? level = null,Object? evs = null,Object? ivs = null,Object? nature = null,Object? moves = null,}) {
  return _then(PokemonSet(
species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as String?,ability: freezed == ability ? _self.ability : ability // ignore: cast_nullable_to_non_nullable
as String?,megaAbility: freezed == megaAbility ? _self.megaAbility : megaAbility // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,evs: null == evs ? _self.evs : evs // ignore: cast_nullable_to_non_nullable
as StatSpread,ivs: null == ivs ? _self.ivs : ivs // ignore: cast_nullable_to_non_nullable
as StatSpread,nature: null == nature ? _self.nature : nature // ignore: cast_nullable_to_non_nullable
as Nature,moves: null == moves ? _self.moves : moves // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of PokemonSet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatSpreadCopyWith<$Res> get evs {
  
  return $StatSpreadCopyWith<$Res>(_self.evs, (value) {
    return _then(_self.copyWith(evs: value));
  });
}/// Create a copy of PokemonSet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatSpreadCopyWith<$Res> get ivs {
  
  return $StatSpreadCopyWith<$Res>(_self.ivs, (value) {
    return _then(_self.copyWith(ivs: value));
  });
}
}


/// Adds pattern-matching-related methods to [PokemonSet].
extension PokemonSetPatterns on PokemonSet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PokemonSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PokemonSet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PokemonSet value)  $default,){
final _that = this;
switch (_that) {
case _PokemonSet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PokemonSet value)?  $default,){
final _that = this;
switch (_that) {
case _PokemonSet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String species,  String? nickname,  String? gender,  String? item,  String? ability,  String? megaAbility,  int level,  StatSpread evs,  StatSpread ivs,  Nature nature,  List<String> moves)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PokemonSet() when $default != null:
return $default(_that.species,_that.nickname,_that.gender,_that.item,_that.ability,_that.megaAbility,_that.level,_that.evs,_that.ivs,_that.nature,_that.moves);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String species,  String? nickname,  String? gender,  String? item,  String? ability,  String? megaAbility,  int level,  StatSpread evs,  StatSpread ivs,  Nature nature,  List<String> moves)  $default,) {final _that = this;
switch (_that) {
case _PokemonSet():
return $default(_that.species,_that.nickname,_that.gender,_that.item,_that.ability,_that.megaAbility,_that.level,_that.evs,_that.ivs,_that.nature,_that.moves);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String species,  String? nickname,  String? gender,  String? item,  String? ability,  String? megaAbility,  int level,  StatSpread evs,  StatSpread ivs,  Nature nature,  List<String> moves)?  $default,) {final _that = this;
switch (_that) {
case _PokemonSet() when $default != null:
return $default(_that.species,_that.nickname,_that.gender,_that.item,_that.ability,_that.megaAbility,_that.level,_that.evs,_that.ivs,_that.nature,_that.moves);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PokemonSet implements PokemonSet {
  const _PokemonSet({required this.species, this.nickname, this.gender, this.item, this.ability, this.megaAbility, this.level = 50, this.evs = const StatSpread(), this.ivs = StatSpread.perfectIvs, this.nature = Nature.serious,  List<String> moves = const []}): _moves = moves;
  factory _PokemonSet.fromJson(Map<String, dynamic> json) => _$PokemonSetFromJson(json);

@override final  String species;
@override final  String? nickname;
/// `M` or `F`, when the paste gives one.
@override final  String? gender;
@override final  String? item;
@override final  String? ability;
/// The ability after Mega Evolving, from the artifact's `A → B`.
@override final  String? megaAbility;
/// VGC plays at level 50, so that's the default.
@override@JsonKey() final  int level;
@override@JsonKey() final  StatSpread evs;
@override@JsonKey() final  StatSpread ivs;
/// Showdown's choice when a paste names no nature.
@override@JsonKey() final  Nature nature;
 final  List<String> _moves;
@override@JsonKey() List<String> get moves {
  if (_moves is EqualUnmodifiableListView) return _moves;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_moves);
}


/// Create a copy of PokemonSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PokemonSetCopyWith<_PokemonSet> get copyWith => __$PokemonSetCopyWithImpl<_PokemonSet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PokemonSetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PokemonSet&&(identical(other.species, species) || other.species == species)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.item, item) || other.item == item)&&(identical(other.ability, ability) || other.ability == ability)&&(identical(other.megaAbility, megaAbility) || other.megaAbility == megaAbility)&&(identical(other.level, level) || other.level == level)&&(identical(other.evs, evs) || other.evs == evs)&&(identical(other.ivs, ivs) || other.ivs == ivs)&&(identical(other.nature, nature) || other.nature == nature)&&const DeepCollectionEquality().equals(other.moves, _moves));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,species,nickname,gender,item,ability,megaAbility,level,evs,ivs,nature,const DeepCollectionEquality().hash(_moves));
}

@override
String toString() {
    return 'PokemonSet(species: $species, nickname: $nickname, gender: $gender, item: $item, ability: $ability, megaAbility: $megaAbility, level: $level, evs: $evs, ivs: $ivs, nature: $nature, moves: $moves)';
}


}

/// @nodoc
abstract mixin class _$PokemonSetCopyWith<$Res> implements $PokemonSetCopyWith<$Res> {
  factory _$PokemonSetCopyWith(_PokemonSet value, $Res Function(_PokemonSet) _then) = __$PokemonSetCopyWithImpl;
@override @useResult
$Res call({
 String species, String? nickname, String? gender, String? item, String? ability, String? megaAbility, int level, StatSpread evs, StatSpread ivs, Nature nature, List<String> moves
});


@override $StatSpreadCopyWith<$Res> get evs;@override $StatSpreadCopyWith<$Res> get ivs;

}
/// @nodoc
class __$PokemonSetCopyWithImpl<$Res>
    implements _$PokemonSetCopyWith<$Res> {
  __$PokemonSetCopyWithImpl(this._self, this._then);

  final _PokemonSet _self;
  final $Res Function(_PokemonSet) _then;

/// Create a copy of PokemonSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? species = null,Object? nickname = freezed,Object? gender = freezed,Object? item = freezed,Object? ability = freezed,Object? megaAbility = freezed,Object? level = null,Object? evs = null,Object? ivs = null,Object? nature = null,Object? moves = null,}) {
  return _then(_PokemonSet(
species: null == species ? _self.species : species // ignore: cast_nullable_to_non_nullable
as String,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as String?,ability: freezed == ability ? _self.ability : ability // ignore: cast_nullable_to_non_nullable
as String?,megaAbility: freezed == megaAbility ? _self.megaAbility : megaAbility // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,evs: null == evs ? _self.evs : evs // ignore: cast_nullable_to_non_nullable
as StatSpread,ivs: null == ivs ? _self.ivs : ivs // ignore: cast_nullable_to_non_nullable
as StatSpread,nature: null == nature ? _self.nature : nature // ignore: cast_nullable_to_non_nullable
as Nature,moves: null == moves ? _self._moves : moves // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of PokemonSet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatSpreadCopyWith<$Res> get evs {
  
  return $StatSpreadCopyWith<$Res>(_self.evs, (value) {
    return _then(_self.copyWith(evs: value));
  });
}/// Create a copy of PokemonSet
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatSpreadCopyWith<$Res> get ivs {
  
  return $StatSpreadCopyWith<$Res>(_self.ivs, (value) {
    return _then(_self.copyWith(ivs: value));
  });
}
}

// dart format on
