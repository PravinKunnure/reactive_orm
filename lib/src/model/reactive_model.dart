// --------------------------
// reactive_model.dart
// --------------------------

import 'package:flutter/material.dart';

typedef VoidCallback = void Function();

class ReactiveModel {
  final Map<Symbol, List<VoidCallback>> _fieldListeners = {};
  final List<ReactiveModel> _nestedModels = [];

  bool _isBatching = false;
  final Set<Symbol> _batchedFields = {};
  bool _disposed = false;

  /// Debug flag for development
  bool debugNotify = false;

  /// ----------------------------
  /// Add listener
  /// ----------------------------
  void addListener(VoidCallback listener, {Symbol? field}) {
    final key = field ?? #*;
    final list = _fieldListeners.putIfAbsent(key, () => []);
    if (!list.contains(listener)) {
      list.add(listener);
    }
  }

  void removeListener(VoidCallback listener, {Symbol? field}) {
    final key = field ?? #*;
    _fieldListeners[key]?.remove(listener);
  }

  /// ----------------------------
  /// Notify listeners
  /// ----------------------------
  void notifyListeners([Symbol? field]) {
    if (_isBatching) {
      if (field != null) _batchedFields.add(field);
      return;
    }

    if (debugNotify) {
      debugPrint("ReactiveModel($runtimeType) notify: $field");
    }

    final notified = <VoidCallback>{};

    // Field-specific listeners
    final fieldListeners = List<VoidCallback>.from(
      _fieldListeners[field] ?? const [],
    );
    for (final l in fieldListeners) {
      if (notified.add(l)) l();
    }

    // Global listeners
    final globalListeners = List<VoidCallback>.from(
      _fieldListeners[#*] ?? const [],
    );
    for (final l in globalListeners) {
      if (notified.add(l)) l();
    }
  }

  /// ----------------------------
  /// Nested models
  /// ----------------------------
  void addNested(ReactiveModel nested, {Symbol? field}) {
    if (_nestedModels.contains(nested)) return;
    _nestedModels.add(nested);

    nested.addListener(() {
      if (debugNotify) {
        debugPrint(
          'Nested change: ${nested.runtimeType} -> ${field ?? #nested}',
        );
      }
      notifyListeners(field ?? #nested);
    });
  }

  /// ----------------------------
  /// Batch updates
  /// ----------------------------
  void batch(VoidCallback fn) {
    _isBatching = true;
    try {
      fn();
    } finally {
      _isBatching = false;
      for (final field in _batchedFields) {
        notifyListeners(field);
      }
      _batchedFields.clear();
    }
  }

  /// ----------------------------
  /// Dispose
  /// ----------------------------
  void dispose() {
    if (_disposed) return;
    _disposed = true;

    _fieldListeners.clear();
    for (final nested in _nestedModels) {
      nested.dispose();
    }
    _nestedModels.clear();
  }
}

///Version 1.0.0
// typedef VoidCallback = void Function();
//
// class ReactiveModel {
//   final Map<Symbol, List<VoidCallback>> _fieldListeners = {};
//   final List<ReactiveModel> _nestedModels = [];
//
//   bool _isBatching = false;
//   final Set<Symbol> _batchedFields = {}; // ✅ WHY Set? Explained below
//
//   /// ----------------------------
//   /// Add listener
//   /// ----------------------------
//   void addListener(VoidCallback listener, {Symbol? field}) {
//     final key = field ?? #*; // wildcard
//     _fieldListeners.putIfAbsent(key, () => []).add(listener);
//   }
//
//   void removeListener(VoidCallback listener, {Symbol? field}) {
//     final key = field ?? #*;
//     _fieldListeners[key]?.remove(listener);
//   }
//
//   /// ----------------------------
//   /// Notify listeners
//   /// ----------------------------
//   void notifyListeners([Symbol? field]) {
//     if (_isBatching) {
//       if (field != null) _batchedFields.add(field);
//       return;
//     }
//
//     final notified = <VoidCallback>{};
//
//     // Field-specific
//     if (field != null) {
//       for (final l in _fieldListeners[field] ?? []) {
//         if (notified.add(l)) l();
//       }
//     }
//
//     // Global listeners
//     for (final l in _fieldListeners[#*] ?? []) {
//       if (notified.add(l)) l();
//     }
//   }
//
//   /// ----------------------------
//   /// Nested models
//   /// ----------------------------
//   void addNested(ReactiveModel nested) {
//     if (_nestedModels.contains(nested)) return;
//     _nestedModels.add(nested);
//     nested.addListener(() => notifyListeners());
//   }
//
//   /// ----------------------------
//   /// Batch updates
//   /// ----------------------------
//   void batch(VoidCallback fn) {
//     _isBatching = true;
//     try {
//       fn();
//     } finally {
//       _isBatching = false;
//       for (final field in _batchedFields) {
//         notifyListeners(field);
//       }
//       _batchedFields.clear();
//     }
//   }
//
//   /// ----------------------------
//   /// Dispose
//   /// ----------------------------
//   void dispose() {
//     _fieldListeners.clear();
//     for (final nested in _nestedModels) {
//       nested.dispose();
//     }
//     _nestedModels.clear();
//   }
// }

///Version 0.0.9
// typedef VoidCallback = void Function();
//
// class ReactiveModel {
//   final Map<Symbol, List<VoidCallback>> _fieldListeners = {};
//   final List<ReactiveModel> _nestedModels = [];
//   bool _isBatching = false;
//   final Set<Symbol> _batchedFields = {};
//
//   // Add listener for a specific field or all fields
//   void addListener(VoidCallback listener, {Symbol? field}) {
//     final key = field ?? #*; // #* = wildcard for all fields
//     _fieldListeners.putIfAbsent(key, () => []).add(listener);
//   }
//
//   void removeListener(VoidCallback listener, {Symbol? field}) {
//     final key = field ?? #*;
//     _fieldListeners[key]?.remove(listener);
//   }
//
//   void notifyListeners([Symbol? field]) {
//     if (_isBatching) {
//       if (field != null) _batchedFields.add(field);
//       return;
//     }
//
//     final notified = <VoidCallback>{};
//
//     // Field-specific listeners
//     if (field != null) {
//       for (final l in _fieldListeners[field] ?? []) {
//         if (!notified.contains(l)) {
//           l();
//           notified.add(l);
//         }
//       }
//     }
//
//     // Global listeners
//     for (final l in _fieldListeners[#*] ?? []) {
//       if (!notified.contains(l)) {
//         l();
//         notified.add(l);
//       }
//     }
//   }
//
//   void addNested(ReactiveModel nested) {
//     if (_nestedModels.contains(nested)) return; // prevent duplicates
//     _nestedModels.add(nested);
//     nested.addListener(() => notifyListeners());
//   }
//
//   /// Batch updates to avoid multiple rebuilds
//   void batch(VoidCallback fn) {
//     _isBatching = true;
//     try {
//       fn();
//     } finally {
//       _isBatching = false;
//       for (var field in _batchedFields) {
//         notifyListeners(field);
//       }
//       _batchedFields.clear();
//     }
//   }
//
//   /// Debug helper: returns listener counts per field
//   Map<String, int> get listenerCount {
//     return {
//       for (var entry in _fieldListeners.entries)
//         '${entry.key}': entry.value.length,
//     };
//   }
//
//   /// Dispose all listeners
//   void dispose() {
//     _fieldListeners.clear();
//     for (var nested in _nestedModels) {
//       nested.dispose();
//     }
//     _nestedModels.clear();
//   }
// }

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
