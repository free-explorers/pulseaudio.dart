## 0.0.9
* expose `available` on sinks and sources based on port availability

## 0.0.7
* link dynamic lib to `libpulse.so.0` instead of `libpulse.so`

## 0.0.6
* refactor to improve documentation

## 0.0.5
* fix linux platform

## 0.0.4
* fix example

## 0.0.3
* fix readme

## 0.0.2

New proper api
* Future<List<PulseAudioSource>> getSourceList
* Future<List<PulseAudioSink>> getSinkList
* Future<PulseAudioServerInfo> getServerInfo()
* Future<void> setDefaultSource(PulseAudioSource source)
* Future<void> setDefaultSink(PulseAudioSink sink)
* Future<void> setSourceVolume(PulseAudioSource source, double volume)
* Future<void> setSinkVolume(PulseAudioSink sink, double volume)
* Future<void> setSourceMute(PulseAudioSource source, bool mute)

Signals
* Stream<PulseAudioServerInfo> onServerInfoChanged
* Stream<PulseAudioSource> onSourceChanged
* Stream<PulseAudioSink> onSinkChanged

## 0.0.1

* Initial release.
