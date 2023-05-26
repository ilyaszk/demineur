import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Fonction pour pouvoir lire sur stdin en asynchrone
//  ce qui permet de réaliser un "timeout" si besoin

/// [stdin] as a broadcast [Stream] of lines.
Stream<String> _stdinLineStreamBroadcaster = stdin
    .transform(utf8.decoder)
    .transform(const LineSplitter()).asBroadcastStream() ;

/// Reads a single line from [stdin] asynchronously.
Future<String> readLine() async {
  var lineCompleter = Completer<String>();
  var listener = _stdinLineStreamBroadcaster.listen((line) {
    if (!lineCompleter.isCompleted) {
      lineCompleter.complete(line);
    }
  });
  return lineCompleter.future.then((line) {
    listener.cancel();
    return line;
  });
}