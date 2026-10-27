import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulseaudio/src/generated_bindings.dart';
import 'package:pulseaudio/src/pulse_isolate.dart';

part 'source.freezed.dart';

@freezed
abstract class PulseAudioSource with _$PulseAudioSource {
  const factory PulseAudioSource({
    required int index,
    required String name,
    required String description,
    required bool mute,
    required double volume,
    @Default(true) bool available,
  }) = _PulseAudioSource;

  factory PulseAudioSource.fromNative(pa_source_info source) {
    final Pointer<pa_cvolume> volumePointer =
        calloc<pa_cvolume>(); // Allocate memory for pa_cvolume
    volumePointer.ref =
        source.volume; // Copy the struct value to the allocated memory
    final volumeAvg = pa.pa_cvolume_avg(volumePointer) / PA_VOLUME_NORM;
    calloc.free(volumePointer); // Free the allocated memory

    return PulseAudioSource(
      index: source.index,
      name: source.name.cast<Utf8>().toDartString(),
      description: source.description.cast<Utf8>().toDartString(),
      mute: source.mute == 1,
      volume: volumeAvg,
      available: _hasAvailablePort(source),
    );
  }
}

bool _hasAvailablePort(pa_source_info device) {
  if (device.n_ports == 0 || device.ports == nullptr) {
    return true;
  }
  for (var i = 0; i < device.n_ports; i++) {
    final port = device.ports[i].ref;
    if (port.available != pa_port_available.PA_PORT_AVAILABLE_NO.value) {
      return true;
    }
  }
  return false;
}
