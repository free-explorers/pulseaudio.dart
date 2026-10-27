// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PulseAudioSource {
  int get index;
  String get name;
  String get description;
  bool get mute;
  double get volume;
  bool get available;

  /// Create a copy of PulseAudioSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PulseAudioSourceCopyWith<PulseAudioSource> get copyWith =>
      _$PulseAudioSourceCopyWithImpl<PulseAudioSource>(
          this as PulseAudioSource, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PulseAudioSource &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.mute, mute) || other.mute == mute) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.available, available) ||
                other.available == available));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, index, name, description, mute, volume, available);

  @override
  String toString() {
    return 'PulseAudioSource(index: $index, name: $name, description: $description, mute: $mute, volume: $volume, available: $available)';
  }
}

/// @nodoc
abstract mixin class $PulseAudioSourceCopyWith<$Res> {
  factory $PulseAudioSourceCopyWith(
          PulseAudioSource value, $Res Function(PulseAudioSource) _then) =
      _$PulseAudioSourceCopyWithImpl;
  @useResult
  $Res call(
      {int index,
      String name,
      String description,
      bool mute,
      double volume,
      bool available});
}

/// @nodoc
class _$PulseAudioSourceCopyWithImpl<$Res>
    implements $PulseAudioSourceCopyWith<$Res> {
  _$PulseAudioSourceCopyWithImpl(this._self, this._then);

  final PulseAudioSource _self;
  final $Res Function(PulseAudioSource) _then;

  /// Create a copy of PulseAudioSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? name = null,
    Object? description = null,
    Object? mute = null,
    Object? volume = null,
    Object? available = null,
  }) {
    return _then(_self.copyWith(
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      mute: null == mute
          ? _self.mute
          : mute // ignore: cast_nullable_to_non_nullable
              as bool,
      volume: null == volume
          ? _self.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
      available: null == available
          ? _self.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _PulseAudioSource implements PulseAudioSource {
  const _PulseAudioSource(
      {required this.index,
      required this.name,
      required this.description,
      required this.mute,
      required this.volume,
      this.available = true});

  @override
  final int index;
  @override
  final String name;
  @override
  final String description;
  @override
  final bool mute;
  @override
  final double volume;
  @override
  @JsonKey()
  final bool available;

  /// Create a copy of PulseAudioSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PulseAudioSourceCopyWith<_PulseAudioSource> get copyWith =>
      __$PulseAudioSourceCopyWithImpl<_PulseAudioSource>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PulseAudioSource &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.mute, mute) || other.mute == mute) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.available, available) ||
                other.available == available));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, index, name, description, mute, volume, available);

  @override
  String toString() {
    return 'PulseAudioSource(index: $index, name: $name, description: $description, mute: $mute, volume: $volume, available: $available)';
  }
}

/// @nodoc
abstract mixin class _$PulseAudioSourceCopyWith<$Res>
    implements $PulseAudioSourceCopyWith<$Res> {
  factory _$PulseAudioSourceCopyWith(
          _PulseAudioSource value, $Res Function(_PulseAudioSource) _then) =
      __$PulseAudioSourceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int index,
      String name,
      String description,
      bool mute,
      double volume,
      bool available});
}

/// @nodoc
class __$PulseAudioSourceCopyWithImpl<$Res>
    implements _$PulseAudioSourceCopyWith<$Res> {
  __$PulseAudioSourceCopyWithImpl(this._self, this._then);

  final _PulseAudioSource _self;
  final $Res Function(_PulseAudioSource) _then;

  /// Create a copy of PulseAudioSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? index = null,
    Object? name = null,
    Object? description = null,
    Object? mute = null,
    Object? volume = null,
    Object? available = null,
  }) {
    return _then(_PulseAudioSource(
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      mute: null == mute
          ? _self.mute
          : mute // ignore: cast_nullable_to_non_nullable
              as bool,
      volume: null == volume
          ? _self.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
      available: null == available
          ? _self.available
          : available // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
