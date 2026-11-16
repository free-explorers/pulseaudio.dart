import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:pulseaudio/src/generated_bindings.dart';
import 'package:pulseaudio/src/model/isolate_request.dart';
import 'package:pulseaudio/src/model/isolate_response.dart';
import 'package:pulseaudio/src/model/server_info.dart';
import 'package:pulseaudio/src/model/sink.dart';
import 'package:pulseaudio/src/model/source.dart';

final PulseAudioBindings pa =
    PulseAudioBindings(DynamicLibrary.open('libpulse.so.0'));

class PulseIsolate {
  static PulseIsolate? _instance;

  final ret = calloc<Int>();
  final Pointer<pa_mainloop> mainloop;
  final Pointer<pa_mainloop_api> mainloopApi;
  final Pointer<pa_context> context;
  final SendPort _sendPort;

  final operationCallbackMap = <Pointer<pa_operation>, Function()>{};

  final responsePerIdMap = <int, IsolateResponse>{};

  PulseIsolate._(this._sendPort, this.mainloop, this.mainloopApi, this.context);

  factory PulseIsolate(SendPort sendPort) {
    if (_instance != null) return _instance!;
    final mainloop = pa.pa_mainloop_new();
    final mainloopApi = pa.pa_mainloop_get_api(mainloop);
    final context =
        pa.pa_context_new(mainloopApi, 'PulseClientDart'.toNativeUtf8().cast());
    pa.pa_context_connect(
        context, nullptr, pa_context_flags.PA_CONTEXT_NOAUTOSPAWN, nullptr);

    _instance = PulseIsolate._(sendPort, mainloop, mainloopApi, context);

    pa.pa_context_set_state_callback(
      _instance!.context,
      Pointer.fromFunction(_contextSetState),
      nullptr,
    );

    final recPort = ReceivePort();
    _instance!._sendPort.send(recPort.sendPort);

    recPort.cast<IsolateRequest>().listen((message) {
      switch (message) {
        case DisposeRequest():
          dispose();
          break;
        case SetSinkVolumeRequest():
          _setSinkVolume(message.requestId, message.sinkName, message.volume);
          break;
        case SetSourceVolumeRequest():
          _setSourceVolume(
              message.requestId, message.sourceName, message.volume);
          break;
        case SetSinkMuteRequest():
          _setSinkMute(message.requestId, message.sinkName, message.mute);
          break;
        case SetSourceMuteRequest():
          _setSourceMute(message.requestId, message.sourceName, message.mute);
          break;
        case SetDefaultSinkRequest():
          _setDefaultSink(message.requestId, message.sinkName);
          break;
        case SetDefaultSourceRequest():
          _setDefaultSource(message.requestId, message.sourceName);
          break;
        case GetSinkListRequest():
          _getSinkList(message.requestId);
          break;
        case GetSourceListRequest():
          _getSourceList(message.requestId);
          break;
        case GetServerInfoRequest():
          _getServerInfo(message.requestId);
          break;
      }
    });

    final exitPort = ReceivePort();
    exitPort.listen((_) {
      PulseIsolate.dispose();
      exitPort.close();
    });
    Isolate.current.addOnExitListener(exitPort.sendPort);

    _runMainLoop();
    return _instance!;
  }

  static Future<void> _runMainLoop() async {
    if (_instance == null) return;
    if (_instance!.operationCallbackMap.isEmpty) {
      // Prepare the main loop for events
      pa.pa_mainloop_prepare(_instance!.mainloop, 50 * 1000);
      // Check for events without blocking
      pa.pa_mainloop_poll(_instance!.mainloop);
      pa.pa_mainloop_dispatch(_instance!.mainloop);
    } else {
      while (_instance!.operationCallbackMap.isNotEmpty) {
        pa.pa_mainloop_iterate(_instance!.mainloop, 1, _instance!.ret);

        final operations = _instance!.operationCallbackMap.keys.toList();
        for (final operation in operations) {
          if (pa.pa_operation_get_state(operation) ==
              pa_operation_state.PA_OPERATION_DONE) {
            final callback = _instance!.operationCallbackMap[operation]!;
            callback.call();
            _instance!.operationCallbackMap.remove(operation);
            pa.pa_operation_unref(operation);
          }
        }
      }
    }
    Timer.run(_runMainLoop);
  }

  static void dispose() {
    pa.pa_context_disconnect(_instance!.context);
    pa.pa_context_unref(_instance!.context);
    pa.pa_mainloop_free(_instance!.mainloop);
    calloc.free(_instance!.ret);
    _instance = null;
    Isolate.current.kill(priority: Isolate.immediate);
  }

  static void _contextSetState(
    Pointer<pa_context> context,
    Pointer<Void> userdata,
  ) {
    final state = pa.pa_context_get_state(context);
    switch (state) {
      case pa_context_state.PA_CONTEXT_CONNECTING:
      case pa_context_state.PA_CONTEXT_AUTHORIZING:
      case pa_context_state.PA_CONTEXT_SETTING_NAME:
        break;
      case pa_context_state.PA_CONTEXT_READY:
        pa.pa_context_set_subscribe_callback(
          context,
          Pointer.fromFunction(_onSubscribe),
          userdata,
        );
        pa.pa_context_subscribe(
          context,
          pa_subscription_mask.PA_SUBSCRIPTION_MASK_ALL,
          nullptr,
          userdata,
        );

        _instance!._sendPort.send(const IsolateResponse.ready());
        break;
      case pa_context_state.PA_CONTEXT_TERMINATED:
        break;
      case pa_context_state.PA_CONTEXT_FAILED:
        // ignore: unused_local_variable
        final error = pa.pa_strerror(pa.pa_context_errno(context));
        break;
      case pa_context_state.PA_CONTEXT_UNCONNECTED:
        break;
    }
  }

  static void _getSinkList(int requestId) {
    final requestIdNative = calloc<Int>()
      ..value = requestId; // Allocate memory explicitly

    _instance!.responsePerIdMap[requestId] =
        OnSinkListResponse(requestId: requestId, list: []);
    final operation = pa.pa_context_get_sink_info_list(
      _instance!.context,
      Pointer.fromFunction(_onSinkListInfo),
      requestIdNative.cast(),
    );

    _instance!.operationCallbackMap[operation] = () {
      _instance!._sendPort.send(_instance!.responsePerIdMap[requestId]!);
      calloc.free(requestIdNative); // Free memory when the operation is done
    };
  }

  static void _onSinkListInfo(
    Pointer<pa_context> context,
    Pointer<pa_sink_info> sink,
    int eol,
    Pointer<Void> userdata,
  ) {
    if (eol > 0) {
      return;
    }
    final requestId = userdata.cast<Int>().value;
    final response =
        _instance!.responsePerIdMap[requestId]! as OnSinkListResponse;

    _instance!.responsePerIdMap[requestId] = response.copyWith(
        list: [...response.list, PulseAudioSink.fromNative(sink.ref)]);
  }

  static void _getSourceList(int requestId) {
    final requestIdNative = calloc<Int>()
      ..value = requestId; // Allocate memory explicitly

    _instance!.responsePerIdMap[requestId] =
        OnSourceListResponse(requestId: requestId, list: []);
    final operation = pa.pa_context_get_source_info_list(
      _instance!.context,
      Pointer.fromFunction(_onSourceListInfo),
      requestIdNative.cast(),
    );

    _instance!.operationCallbackMap[operation] = () {
      _instance!._sendPort.send(_instance!.responsePerIdMap[requestId]!);
      calloc.free(requestIdNative); // Free memory when the operation is done
    };
  }

  static void _onSourceListInfo(
    Pointer<pa_context> context,
    Pointer<pa_source_info> source,
    int eol,
    Pointer<Void> userdata,
  ) {
    if (eol > 0) {
      return;
    }
    final requestId = userdata.cast<Int>().value;
    final response =
        _instance!.responsePerIdMap[requestId]! as OnSourceListResponse;

    _instance!.responsePerIdMap[requestId] = response.copyWith(
        list: [...response.list, PulseAudioSource.fromNative(source.ref)]);
  }

  static void _getServerInfo(int requestId) {
    final requestIdNative = calloc<Int>()
      ..value = requestId; // Allocate memory explicitly

    final operation = pa.pa_context_get_server_info(
      _instance!.context,
      Pointer.fromFunction(_onServerInfo),
      requestIdNative.cast(),
    );

    _instance!.operationCallbackMap[operation] = () {
      _instance!._sendPort.send(_instance!.responsePerIdMap[requestId]!);
      calloc.free(requestIdNative); // Free memory when the operation is done
    };
  }

  static void _onServerInfo(
    Pointer<pa_context> context,
    Pointer<pa_server_info> serverInfo,
    Pointer<Void> userdata,
  ) {
    final requestId = userdata.cast<Int>().value;
    _instance!.responsePerIdMap[requestId] = OnServerInfoResponse(
        requestId: requestId,
        info: PulseAudioServerInfo.fromNative(serverInfo.ref));
  }

  static void _onServerInfoChanged(
    Pointer<pa_context> context,
    Pointer<pa_server_info> serverInfo,
    Pointer<Void> userdata,
  ) {
    _instance!._sendPort.send(IsolateResponse.onServerInfoChanged(
        serverInfo: PulseAudioServerInfo.fromNative(serverInfo.ref)));
  }

  static void _onSinkInfoChanged(
    Pointer<pa_context> context,
    Pointer<pa_sink_info> sink,
    int eol,
    Pointer<Void> userdata,
  ) {
    // The first call doesn't have info of the sink
    if (sink != nullptr) {
      _instance!._sendPort.send(IsolateResponse.onSinkChanged(
        sink: PulseAudioSink.fromNative(sink.ref),
      ));
    }
  }

  static void _onSourceInfoChanged(
    Pointer<pa_context> context,
    Pointer<pa_source_info> source,
    int eol,
    Pointer<Void> userdata,
  ) {
    // The first call doesn't have info of the sink
    if (source != nullptr) {
      _instance!._sendPort.send(IsolateResponse.onSourceChanged(
          source: PulseAudioSource.fromNative(source.ref)));
    }
  }

  static void _onSubscribe(
    Pointer<pa_context> context,
    int type,
    int idx,
    Pointer<Void> userdata,
  ) {
    final eventFacility = type & PA_SUBSCRIPTION_EVENT_FACILITY_MASK;
    final eventType = type & PA_SUBSCRIPTION_EVENT_TYPE_MASK;

    Pointer<pa_operation> op = nullptr;

    switch (eventFacility) {
      case PA_SUBSCRIPTION_EVENT_SERVER:
        pa.pa_context_get_server_info(
          context,
          Pointer.fromFunction(_onServerInfoChanged),
          userdata,
        );
        break;
      case PA_SUBSCRIPTION_EVENT_SINK:
        if (eventType == PA_SUBSCRIPTION_EVENT_REMOVE) {
          _instance!._sendPort.send(IsolateResponse.onSinkRemoved(index: idx));
        } else {
          op = pa.pa_context_get_sink_info_by_index(
            context,
            idx,
            Pointer.fromFunction(_onSinkInfoChanged),
            userdata,
          );
        }
        break;

      case PA_SUBSCRIPTION_EVENT_SOURCE:
        if (eventType == PA_SUBSCRIPTION_EVENT_REMOVE) {
          _instance!._sendPort
              .send(IsolateResponse.onSourceRemoved(index: idx));
        } else {
          op = pa.pa_context_get_source_info_by_index(
            context,
            idx,
            Pointer.fromFunction(_onSourceInfoChanged),
            userdata,
          );
        }
        break;

      case PA_SUBSCRIPTION_EVENT_CARD:
        // A card change can alter its sinks and sources (port availability,
        // active port, profile) without the server sending a sink or source
        // event for them, so fetch them again.
        if (eventType != PA_SUBSCRIPTION_EVENT_REMOVE) {
          _refreshCardDevices(context, idx);
        }
        break;
    }

    if (op.address != nullptr.address) pa.pa_operation_unref(op);
  }

  /// Fetches the sinks and sources of the card at [cardIndex] again and
  /// reports each of them as changed.
  static void _refreshCardDevices(Pointer<pa_context> context, int cardIndex) {
    final sinkCard = calloc<Uint32>()..value = cardIndex;
    final sinkOp = pa.pa_context_get_sink_info_list(
      context,
      Pointer.fromFunction(_onCardSinkInfo),
      sinkCard.cast(),
    );
    if (sinkOp == nullptr) {
      calloc.free(sinkCard);
    } else {
      pa.pa_operation_unref(sinkOp);
    }

    final sourceCard = calloc<Uint32>()..value = cardIndex;
    final sourceOp = pa.pa_context_get_source_info_list(
      context,
      Pointer.fromFunction(_onCardSourceInfo),
      sourceCard.cast(),
    );
    if (sourceOp == nullptr) {
      calloc.free(sourceCard);
    } else {
      pa.pa_operation_unref(sourceOp);
    }
  }

  static void _onCardSinkInfo(
    Pointer<pa_context> context,
    Pointer<pa_sink_info> sink,
    int eol,
    Pointer<Void> userdata,
  ) {
    final cardIndex = userdata.cast<Uint32>();
    // The list ends (eol > 0) or fails (eol < 0) with a call carrying no
    // sink; only then is the card index no longer needed.
    if (eol != 0) {
      calloc.free(cardIndex);
      return;
    }
    if (sink == nullptr) return;
    if (sink.ref.card == cardIndex.value) {
      _instance!._sendPort.send(IsolateResponse.onSinkChanged(
        sink: PulseAudioSink.fromNative(sink.ref),
      ));
    }
  }

  static void _onCardSourceInfo(
    Pointer<pa_context> context,
    Pointer<pa_source_info> source,
    int eol,
    Pointer<Void> userdata,
  ) {
    final cardIndex = userdata.cast<Uint32>();
    // The list ends (eol > 0) or fails (eol < 0) with a call carrying no
    // source; only then is the card index no longer needed.
    if (eol != 0) {
      calloc.free(cardIndex);
      return;
    }
    if (source == nullptr) return;
    if (source.ref.card == cardIndex.value) {
      _instance!._sendPort.send(IsolateResponse.onSourceChanged(
        source: PulseAudioSource.fromNative(source.ref),
      ));
    }
  }

  static _setSinkVolume(int requestId, String name, double volume) {
    using((Arena arena) {
      final pVolume = arena<pa_cvolume>();
      pa.pa_cvolume_init(pVolume);
      pa.pa_cvolume_set(pVolume, 2, (volume * PA_VOLUME_NORM).ceil());

      final operation = pa.pa_context_set_sink_volume_by_name(
        _instance!.context,
        name.toNativeUtf8().cast(),
        pVolume,
        nullptr,
        nullptr,
      );

      _instance!.operationCallbackMap[operation] = () {
        _instance!._sendPort.send(SetSinkVolumeResponse(requestId: requestId));
      };
    });
  }

  static _setSourceVolume(int requestId, String name, double volume) {
    using((Arena arena) {
      final pVolume = arena<pa_cvolume>();
      pa.pa_cvolume_init(pVolume);
      pa.pa_cvolume_set(pVolume, 2, (volume * PA_VOLUME_NORM).ceil());

      final operation = pa.pa_context_set_source_volume_by_name(
        _instance!.context,
        name.toNativeUtf8().cast(),
        pVolume,
        nullptr,
        nullptr,
      );
      _instance!.operationCallbackMap[operation] = () {
        _instance!._sendPort
            .send(SetSourceVolumeResponse(requestId: requestId));
      };
    });
  }

  static _setSinkMute(int requestId, String name, bool mute) {
    final operation = pa.pa_context_set_sink_mute_by_name(
      _instance!.context,
      name.toNativeUtf8().cast(),
      mute ? 1 : 0,
      nullptr,
      nullptr,
    );
    _instance!.operationCallbackMap[operation] = () {
      _instance!._sendPort.send(SetSinkMuteResponse(requestId: requestId));
    };
  }

  static _setSourceMute(int requestId, String name, bool mute) {
    final operation = pa.pa_context_set_source_mute_by_name(
      _instance!.context,
      name.toNativeUtf8().cast(),
      mute ? 1 : 0,
      nullptr,
      nullptr,
    );
    _instance!.operationCallbackMap[operation] = () {
      _instance!._sendPort.send(SetSourceMuteResponse(requestId: requestId));
    };
  }

  static _setDefaultSink(int requestId, String name) {
    final operation = pa.pa_context_set_default_sink(
      _instance!.context,
      name.toNativeUtf8().cast(),
      nullptr,
      nullptr,
    );
    _instance!.operationCallbackMap[operation] = () {
      _instance!._sendPort.send(SetDefaultSinkResponse(requestId: requestId));
    };
  }

  static _setDefaultSource(int requestId, String name) {
    final operation = pa.pa_context_set_default_source(
      _instance!.context,
      name.toNativeUtf8().cast(),
      nullptr,
      nullptr,
    );
    _instance!.operationCallbackMap[operation] = () {
      _instance!._sendPort.send(SetDefaultSourceResponse(requestId: requestId));
    };
  }
}
