// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sink.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PulseAudioSink {
  int get index;
  String get name;
  String get description;
  bool get mute;
  double get volume;
  bool get available;

  /// Create a copy of PulseAudioSink
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PulseAudioSinkCopyWith<PulseAudioSink> get copyWith =>
      _$PulseAudioSinkCopyWithImpl<PulseAudioSink>(
          this as PulseAudioSink, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PulseAudioSink &&
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
    return 'PulseAudioSink(index: $index, name: $name, description: $description, mute: $mute, volume: $volume, available: $available)';
  }
}

/// @nodoc
abstract mixin class $PulseAudioSinkCopyWith<$Res> {
  factory $PulseAudioSinkCopyWith(
          PulseAudioSink value, $Res Function(PulseAudioSink) _then) =
      _$PulseAudioSinkCopyWithImpl;
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
class _$PulseAudioSinkCopyWithImpl<$Res>
    implements $PulseAudioSinkCopyWith<$Res> {
  _$PulseAudioSinkCopyWithImpl(this._self, this._then);

  final PulseAudioSink _self;
  final $Res Function(PulseAudioSink) _then;

  /// Create a copy of PulseAudioSink
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

class _PulseAudioSink implements PulseAudioSink {
  const _PulseAudioSink(
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

  /// Create a copy of PulseAudioSink
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PulseAudioSinkCopyWith<_PulseAudioSink> get copyWith =>
      __$PulseAudioSinkCopyWithImpl<_PulseAudioSink>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PulseAudioSink &&
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
    return 'PulseAudioSink(index: $index, name: $name, description: $description, mute: $mute, volume: $volume, available: $available)';
  }
}

/// @nodoc
abstract mixin class _$PulseAudioSinkCopyWith<$Res>
    implements $PulseAudioSinkCopyWith<$Res> {
  factory _$PulseAudioSinkCopyWith(
          _PulseAudioSink value, $Res Function(_PulseAudioSink) _then) =
      __$PulseAudioSinkCopyWithImpl;
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
class __$PulseAudioSinkCopyWithImpl<$Res>
    implements _$PulseAudioSinkCopyWith<$Res> {
  __$PulseAudioSinkCopyWithImpl(this._self, this._then);

  final _PulseAudioSink _self;
  final $Res Function(_PulseAudioSink) _then;

  /// Create a copy of PulseAudioSink
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
    return _then(_PulseAudioSink(
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
