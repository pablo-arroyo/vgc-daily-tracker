// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'type_chart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TypeChart {

 Map<String, Map<String, double>> get attacking;
/// Create a copy of TypeChart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TypeChartCopyWith<TypeChart> get copyWith => _$TypeChartCopyWithImpl<TypeChart>(this as TypeChart, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TypeChart;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TypeChart&&const DeepCollectionEquality().equals(other.attacking, _this.attacking));
}


@override
int get hashCode {
  final _this = this as TypeChart;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.attacking));
}

@override
String toString() {
  final _this = this as TypeChart;
  return 'TypeChart(attacking: ${_this.attacking})';
}


}

/// @nodoc
abstract mixin class $TypeChartCopyWith<$Res>  {
  factory $TypeChartCopyWith(TypeChart value, $Res Function(TypeChart) _then) = _$TypeChartCopyWithImpl;
@useResult
$Res call({
 Map<String, Map<String, double>> attacking
});




}
/// @nodoc
class _$TypeChartCopyWithImpl<$Res>
    implements $TypeChartCopyWith<$Res> {
  _$TypeChartCopyWithImpl(this._self, this._then);

  final TypeChart _self;
  final $Res Function(TypeChart) _then;

/// Create a copy of TypeChart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attacking = null,}) {
  return _then(TypeChart(
null == attacking ? _self.attacking : attacking // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, double>>,
  ));
}

}


/// Adds pattern-matching-related methods to [TypeChart].
extension TypeChartPatterns on TypeChart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TypeChart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TypeChart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TypeChart value)  $default,){
final _that = this;
switch (_that) {
case _TypeChart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TypeChart value)?  $default,){
final _that = this;
switch (_that) {
case _TypeChart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, Map<String, double>> attacking)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TypeChart() when $default != null:
return $default(_that.attacking);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, Map<String, double>> attacking)  $default,) {final _that = this;
switch (_that) {
case _TypeChart():
return $default(_that.attacking);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, Map<String, double>> attacking)?  $default,) {final _that = this;
switch (_that) {
case _TypeChart() when $default != null:
return $default(_that.attacking);case _:
  return null;

}
}

}

/// @nodoc


class _TypeChart extends TypeChart {
  const _TypeChart( Map<String, Map<String, double>> attacking): _attacking = attacking,super._();
  

 final  Map<String, Map<String, double>> _attacking;
@override Map<String, Map<String, double>> get attacking {
  if (_attacking is EqualUnmodifiableMapView) return _attacking;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_attacking);
}


/// Create a copy of TypeChart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypeChartCopyWith<_TypeChart> get copyWith => __$TypeChartCopyWithImpl<_TypeChart>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypeChart&&const DeepCollectionEquality().equals(other.attacking, _attacking));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_attacking));
}

@override
String toString() {
    return 'TypeChart(attacking: $attacking)';
}


}

/// @nodoc
abstract mixin class _$TypeChartCopyWith<$Res> implements $TypeChartCopyWith<$Res> {
  factory _$TypeChartCopyWith(_TypeChart value, $Res Function(_TypeChart) _then) = __$TypeChartCopyWithImpl;
@override @useResult
$Res call({
 Map<String, Map<String, double>> attacking
});




}
/// @nodoc
class __$TypeChartCopyWithImpl<$Res>
    implements _$TypeChartCopyWith<$Res> {
  __$TypeChartCopyWithImpl(this._self, this._then);

  final _TypeChart _self;
  final $Res Function(_TypeChart) _then;

/// Create a copy of TypeChart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attacking = null,}) {
  return _then(_TypeChart(
null == attacking ? _self._attacking : attacking // ignore: cast_nullable_to_non_nullable
as Map<String, Map<String, double>>,
  ));
}


}

// dart format on
