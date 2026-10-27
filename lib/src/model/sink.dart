import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulseaudio/src/generated_bindings.dart';
import 'package:pulseaudio/src/pulse_isolate.dart';

part 'sink.freezed.dart';

@freezed
abstract class PulseAudioSink with _$PulseAudioSink {
  const factory PulseAudioSink({
    required int index,
    required String name,
    required String description,
    required bool mute,
    required double volume,
    @Default(true) bool available,
  }) = _PulseAudioSink;

  factory PulseAudioSink.fromNative(pa_sink_info device) {
    final Pointer<pa_cvolume> volumePointer =
        calloc<pa_cvolume>(); // Allocate memory for pa_cvolume
    volumePointer.ref =
        device.volume; // Copy the struct value to the allocated memory
    final volumeAvg = pa.pa_cvolume_avg(volumePointer) / PA_VOLUME_NORM;
    calloc.free(volumePointer); // Free the allocated memory

    return PulseAudioSink(
      index: device.index,
      name: device.name.cast<Utf8>().toDartString(),
      description: device.description.cast<Utf8>().toDartString(),
      mute: device.mute == 1,
      volume: volumeAvg,
      available: _hasAvailablePort(device),
    );
  }
}

bool _hasAvailablePort(pa_sink_info device) {
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
