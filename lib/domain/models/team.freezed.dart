// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Team {

 String get id; String get name; List<PokemonRef> get pokemon;/// Full builds from a Showdown import, one per [pokemon] in the same
/// order, or empty for a team built by picking Pokémon.
 List<PokemonSet> get sets;/// Teams saved before sides existed are the player's own.
 TeamSide get side;/// Free text: scouting notes on an opponent's team, or a game plan for
/// your own. Empty for teams saved before notes existed.
 String get notes;
/// Create a copy of Team
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamCopyWith<Team> get copyWith => _$TeamCopyWithImpl<Team>(this as Team, _$identity);

  /// Serializes this Team to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Team;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Team&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.pokemon, _this.pokemon)&&const DeepCollectionEquality().equals(other.sets, _this.sets)&&(identical(other.side, _this.side) || other.side == _this.side)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Team;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.pokemon),const DeepCollectionEquality().hash(_this.sets),_this.side,_this.notes);
}

@override
String toString() {
  final _this = this as Team;
  return 'Team(id: ${_this.id}, name: ${_this.name}, pokemon: ${_this.pokemon}, sets: ${_this.sets}, side: ${_this.side}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $TeamCopyWith<$Res>  {
  factory $TeamCopyWith(Team value, $Res Function(Team) _then) = _$TeamCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<PokemonRef> pokemon, List<PokemonSet> sets, TeamSide side, String notes
});




}
/// @nodoc
class _$TeamCopyWithImpl<$Res>
    implements $TeamCopyWith<$Res> {
  _$TeamCopyWithImpl(this._self, this._then);

  final Team _self;
  final $Res Function(Team) _then;

/// Create a copy of Team
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? pokemon = null,Object? sets = null,Object? side = null,Object? notes = null,}) {
  return _then(Team(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pokemon: null == pokemon ? _self.pokemon : pokemon // ignore: cast_nullable_to_non_nullable
as List<PokemonRef>,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<PokemonSet>,side: null == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as TeamSide,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Team].
extension TeamPatterns on Team {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Team value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Team() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Team value)  $default,){
final _that = this;
switch (_that) {
case _Team():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Team value)?  $default,){
final _that = this;
switch (_that) {
case _Team() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<PokemonRef> pokemon,  List<PokemonSet> sets,  TeamSide side,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Team() when $default != null:
return $default(_that.id,_that.name,_that.pokemon,_that.sets,_that.side,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<PokemonRef> pokemon,  List<PokemonSet> sets,  TeamSide side,  String notes)  $default,) {final _that = this;
switch (_that) {
case _Team():
return $default(_that.id,_that.name,_that.pokemon,_that.sets,_that.side,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<PokemonRef> pokemon,  List<PokemonSet> sets,  TeamSide side,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _Team() when $default != null:
return $default(_that.id,_that.name,_that.pokemon,_that.sets,_that.side,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Team implements Team {
  const _Team({required this.id, required this.name, required  List<PokemonRef> pokemon,  List<PokemonSet> sets = const [], this.side = TeamSide.mine, this.notes = ''}): _pokemon = pokemon,_sets = sets;
  factory _Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

@override final  String id;
@override final  String name;
 final  List<PokemonRef> _pokemon;
@override List<PokemonRef> get pokemon {
  if (_pokemon is EqualUnmodifiableListView) return _pokemon;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pokemon);
}

/// Full builds from a Showdown import, one per [pokemon] in the same
/// order, or empty for a team built by picking Pokémon.
 final  List<PokemonSet> _sets;
/// Full builds from a Showdown import, one per [pokemon] in the same
/// order, or empty for a team built by picking Pokémon.
@override@JsonKey() List<PokemonSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}

/// Teams saved before sides existed are the player's own.
@override@JsonKey() final  TeamSide side;
/// Free text: scouting notes on an opponent's team, or a game plan for
/// your own. Empty for teams saved before notes existed.
@override@JsonKey() final  String notes;

/// Create a copy of Team
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamCopyWith<_Team> get copyWith => __$TeamCopyWithImpl<_Team>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Team&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.pokemon, _pokemon)&&const DeepCollectionEquality().equals(other.sets, _sets)&&(identical(other.side, side) || other.side == side)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_pokemon),const DeepCollectionEquality().hash(_sets),side,notes);
}

@override
String toString() {
    return 'Team(id: $id, name: $name, pokemon: $pokemon, sets: $sets, side: $side, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$TeamCopyWith<$Res> implements $TeamCopyWith<$Res> {
  factory _$TeamCopyWith(_Team value, $Res Function(_Team) _then) = __$TeamCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<PokemonRef> pokemon, List<PokemonSet> sets, TeamSide side, String notes
});




}
/// @nodoc
class __$TeamCopyWithImpl<$Res>
    implements _$TeamCopyWith<$Res> {
  __$TeamCopyWithImpl(this._self, this._then);

  final _Team _self;
  final $Res Function(_Team) _then;

/// Create a copy of Team
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? pokemon = null,Object? sets = null,Object? side = null,Object? notes = null,}) {
  return _then(_Team(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pokemon: null == pokemon ? _self._pokemon : pokemon // ignore: cast_nullable_to_non_nullable
as List<PokemonRef>,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<PokemonSet>,side: null == side ? _self.side : side // ignore: cast_nullable_to_non_nullable
as TeamSide,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
