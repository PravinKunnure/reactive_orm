import 'package:reactive_orm/reactive_orm.dart';

class Task extends ReactiveModel {
  String _title;
  bool _completed;

  Task({required String title, bool completed = false})
      : _title = title,
        _completed = completed;

  String get title => _title;
  set title(String val) {
    if (_title != val) {
      _title = val;
      notifyListeners('title');
    }
  }

  bool get completed => _completed;
  set completed(bool val) {
    if (_completed != val) {
      _completed = val;
      notifyListeners('completed');
      status = val ? "Task Completed ✅" : "Task Pending ❌";
    }
  }

  String _status = "";
  String get status => _status;
  set status(String val) {
    if (_status != val) {
      _status = val;
      notifyListeners('status');
    }
  }
}



///Try Version
// import 'package:reactive_orm/reactive_orm.dart';
//
// // Task Model
// class Task extends ReactiveModel {
//   String _title;
//   bool _completed;
//
//   Task({required String title, bool completed = false})
//       : _title = title,
//         _completed = completed;
//
//   String get title => _title;
//   set title(String value) {
//     if (_title != value) {
//       _title = value;
//       notifyListeners('title');
//     }
//   }
//
//   bool get completed => _completed;
//   set completed(bool value) {
//     if (_completed != value) {
//       _completed = value;
//       notifyListeners('completed');
//     }
//   }
// }



///Version 0.0.1
// import 'package:reactive_orm/reactive_orm.dart';
//
// class Task extends ReactiveModel {
//   String _title;
//   bool _completed;
//
//   Task({required String title, bool completed = false})
//     : _title = title,
//       _completed = completed;
//
//   String get title => _title;
//   set title(String value) {
//     _title = value;
//     notifyListeners();
//   }
//
//   bool get completed => _completed;
//   set completed(bool value) {
//     _completed = value;
//     notifyListeners();
//   }
// }
