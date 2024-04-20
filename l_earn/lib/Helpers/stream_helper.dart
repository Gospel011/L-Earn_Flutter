import 'dart:async';

class StreamHelper {
  // private stream controller
  final StreamController _streamController = StreamController();

  // get stream
  Stream<dynamic> get stream => _streamController.stream;

  // add value to stream
  void add(dynamic event) => _streamController.sink.add(event);

  // close
  void close() => _streamController.close();
}
