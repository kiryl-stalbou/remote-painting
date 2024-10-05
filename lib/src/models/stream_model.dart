import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract base class StreamModel<S extends Stream<D>, D extends Object?>
    extends ChangeNotifier {
  StreamModel({required S stream}) : _stream = stream {
    initialize(_stream);
  }

  S _stream;
  S get stream => _stream;

  void Function()? onDoneCallback;

  StreamSubscription<D>? _streamSubscription;

  ValueNotifier<bool> isConnected = ValueNotifier(false);

  void initialize(S stream) {
    isConnected.value = true;

    _stream = stream;
    _streamSubscription = stream.listen(
      onData,
      onDone: onDone,
      onError: onError,
    );
  }

  void onData(D data);

  @mustCallSuper
  void onDone() {
    isConnected.value = false;

    onDoneCallback?.call();
    // ignore: discarded_futures
    _streamSubscription?.cancel();
  }

  @mustCallSuper
  void onError(Object e, StackTrace s) {
    log('Stream error', error: e, stackTrace: s);
  }

  @override
  void dispose() {
    onDone();
    super.dispose();
  }
}
