import 'dart:async';

class DebounceHelper {
  static final Map<String, Timer?> _timers = {};
  static final Map<String, DateTime> _lastClickTimes = {};

  static const Duration defaultDebounceTime = Duration(milliseconds: 500);
  static const Duration quickDebounceTime = Duration(milliseconds: 300);
  static const Duration longDebounceTime = Duration(milliseconds: 1000);

  static bool canClick(String key, {Duration debounceTime = defaultDebounceTime}) {
    final now = DateTime.now();
    final lastClick = _lastClickTimes[key];

    if (lastClick == null || now.difference(lastClick) >= debounceTime) {
      _lastClickTimes[key] = now;
      return true;
    }

    return false;
  }

  static void debounce(
    String key,
    VoidCallback callback, {
    Duration duration = defaultDebounceTime,
  }) {
    _timers[key]?.cancel();
    _timers[key] = Timer(duration, callback);
  }

  static void cancelDebounce(String key) {
    _timers[key]?.cancel();
    _timers.remove(key);
  }

  static void clear() {
    for (final timer in _timers.values) {
      timer?.cancel();
    }
    _timers.clear();
    _lastClickTimes.clear();
  }

  static void clearKey(String key) {
    _timers[key]?.cancel();
    _timers.remove(key);
    _lastClickTimes.remove(key);
  }
}

typedef VoidCallback = void Function();

class DebouncedButton {
  DateTime? _lastClickTime;
  final Duration debounceTime;

  DebouncedButton({this.debounceTime = DebounceHelper.defaultDebounceTime});

  bool canExecute() {
    final now = DateTime.now();
    if (_lastClickTime == null || now.difference(_lastClickTime!) >= debounceTime) {
      _lastClickTime = now;
      return true;
    }
    return false;
  }

  void execute(VoidCallback callback) {
    if (canExecute()) {
      callback();
    }
  }

  Future<T?> executeAsync<T>(Future<T> Function() callback) async {
    if (canExecute()) {
      return await callback();
    }
    return null;
  }
}