import 'package:reactive_orm/reactive_orm.dart';

class Task extends ReactiveModel {
  String _title;
  bool _completed;

  Task({required String title, bool completed = false})
    : _title = title,
      _completed = completed;

  String get title => _title;
  set title(String value) {
    _title = value;
    notifyListeners();
  }

  bool get completed => _completed;
  set completed(bool value) {
    _completed = value;
    notifyListeners();
  }
}
