import 'dart:async';
import 'dart:ui';

class Debounces {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debounces({this.milliseconds = 500});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
