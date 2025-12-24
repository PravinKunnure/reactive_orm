import 'dart:async';
import 'dart:ui';

class ReactiveModel {
  final _listeners = <VoidCallback>[];

  // Subscribe to changes
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  // Notify all listeners of change
  void notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  // Placeholder for saving to DB
  Future<void> save() async {}
  Future<void> load() async {}
}
