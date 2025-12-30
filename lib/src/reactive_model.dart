typedef VoidCallback = void Function();

class ReactiveModel {
  final Map<Symbol, List<VoidCallback>> _fieldListeners = {};
  final List<ReactiveModel> _nestedModels = [];
  bool _isBatching = false;
  final Set<Symbol> _batchedFields = {};

  // Add listener for a specific field or all fields
  void addListener(VoidCallback listener, {Symbol? field}) {
    final key = field ?? #*; // #* = wildcard for all fields
    _fieldListeners.putIfAbsent(key, () => []).add(listener);
  }

  void removeListener(VoidCallback listener, {Symbol? field}) {
    final key = field ?? #*;
    _fieldListeners[key]?.remove(listener);
  }

  void notifyListeners([Symbol? field]) {
    if (_isBatching) {
      if (field != null) _batchedFields.add(field);
      return;
    }

    final notified = <VoidCallback>{};

    // Field-specific listeners
    if (field != null) {
      for (final l in _fieldListeners[field] ?? []) {
        if (!notified.contains(l)) {
          l();
          notified.add(l);
        }
      }
    }

    // Global listeners
    for (final l in _fieldListeners[#*] ?? []) {
      if (!notified.contains(l)) {
        l();
        notified.add(l);
      }
    }
  }

  void addNested(ReactiveModel nested) {
    if (_nestedModels.contains(nested)) return; // prevent duplicates
    _nestedModels.add(nested);
    nested.addListener(() => notifyListeners());
  }

  /// Batch updates to avoid multiple rebuilds
  void batch(VoidCallback fn) {
    _isBatching = true;
    try {
      fn();
    } finally {
      _isBatching = false;
      for (var field in _batchedFields) {
        notifyListeners(field);
      }
      _batchedFields.clear();
    }
  }

  /// Debug helper: returns listener counts per field
  Map<String, int> get listenerCount {
    return {
      for (var entry in _fieldListeners.entries)
        '${entry.key}': entry.value.length,
    };
  }

  /// Dispose all listeners
  void dispose() {
    _fieldListeners.clear();
    for (var nested in _nestedModels) {
      nested.dispose();
    }
    _nestedModels.clear();
  }
}

///Version 0.0.7
// import 'dart:ui';
//
// class ReactiveModel {
//   // Field-specific listeners: field name -> listeners
//   final Map<String, List<VoidCallback>> _fieldListeners = {};
//
//   // Add listener for a specific field or all fields if field == null
//   void addListener(VoidCallback listener, {String? field}) {
//     final key = field ?? '*'; // '*' = wildcard for all-fields listeners
//     _fieldListeners.putIfAbsent(key, () => []).add(listener);
//   }
//
//   void removeListener(VoidCallback listener, {String? field}) {
//     final key = field ?? '*';
//     _fieldListeners[key]?.remove(listener);
//   }
//
//   // Notify listeners for a specific field, or all if field == null
//   void notifyListeners([String? field]) {
//     if (field != null) {
//       for (final listener in _fieldListeners[field] ?? []) {
//         listener();
//       }
//     }
//
//     // Notify global listeners
//     for (final listener in _fieldListeners['*'] ?? []) {
//       listener();
//     }
//   }
//
//   // Nested reactive model support
//   void addNested(ReactiveModel nested, {String? field}) {
//     nested.addListener(() => notifyListeners(field));
//   }
// }

///Try Version
// import 'dart:async';
// import 'dart:ui';
//
// class ReactiveModel {
//   // Map of field name → listeners
//   final Map<String, List<VoidCallback>> _fieldListeners = {};
//
//   // Add listener for a specific field or all fields if field == null
//   void addListener(VoidCallback listener, {String? field}) {
//     final key = field ?? '*'; // '*' is a special key for all-fields listeners
//     _fieldListeners.putIfAbsent(key, () => []).add(listener);
//   }
//
//   // Remove listener
//   void removeListener(VoidCallback listener, {String? field}) {
//     final key = field ?? '*';
//     _fieldListeners[key]?.remove(listener);
//   }
//
//   // Notify listeners
//   void notifyListeners([String? field]) {
//     if (field != null) {
//       for (final listener in _fieldListeners[field] ?? []) {
//         listener();
//       }
//     }
//
//     // Notify global listeners
//     for (final listener in _fieldListeners['*'] ?? []) {
//       listener();
//     }
//   }
// }

///Version 0.0.1
// import 'dart:async';
// import 'dart:ui';
//
// class ReactiveModel {
//   final _listeners = <VoidCallback>[];
//
//   // Subscribe to changes
//   void addListener(VoidCallback listener) {
//     _listeners.add(listener);
//   }
//
//   void removeListener(VoidCallback listener) {
//     _listeners.remove(listener);
//   }
//
//   // Notify all listeners of change
//   void notifyListeners() {
//     for (final listener in _listeners) {
//       listener();
//     }
//   }
//
//   // Placeholder for saving to DB
//   Future<void> save() async {}
//   Future<void> load() async {}
// }
