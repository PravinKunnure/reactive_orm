import '../core/reactive_model.dart';

/// --------------------------
/// Relationship Helper v1.2.x
/// --------------------------

/// Many → One relationship
/// Adds `child` to `parent` and keeps optional reference
void addManyToOne(
  ReactiveModel parent,
  ReactiveModel child, {
  Symbol? field,
  bool notifyParent = true,
}) {
  parent.addNested(child, field: field);

  // Optional: store a weak link to parent in child
  if (child is _HasParent) {
    child._parents.add(parent);
  }

  if (notifyParent) {
    parent.notifyListeners(field);
  }
}

/// Remove child from parent (Many → One)
void removeFromParent(
  ReactiveModel parent,
  ReactiveModel child, {
  Symbol? field,
}) {
  parent.nestedModels.remove(child);
  if (child is _HasParent) {
    child._parents.remove(parent);
  }
  parent.notifyListeners(field);
}

/// Many ↔ Many relationship
/// Adds multiple shared children to owner
void addManyToMany(
  ReactiveModel owner,
  List<ReactiveModel> sharedChildren, {
  Symbol? field,
  bool notifyOwner = true,
}) {
  for (final child in sharedChildren) {
    owner.addNested(child, field: field);

    // Optional: track owner in child
    if (child is _HasParent) {
      child._parents.add(owner);
    }
  }
  if (notifyOwner) {
    owner.notifyListeners(field);
  }
}

/// Remove shared children from owner
void removeManyToMany(
  ReactiveModel owner,
  List<ReactiveModel> sharedChildren, {
  Symbol? field,
}) {
  for (final child in sharedChildren) {
    owner.nestedModels.remove(child);
    if (child is _HasParent) child._parents.remove(owner);
  }
  owner.notifyListeners(field);
}

/// ----------------------------
/// Optional Mixin for child tracking
/// ----------------------------
mixin _HasParent on ReactiveModel {
  final Set<ReactiveModel> _parents = {};

  /// Get all parents
  List<ReactiveModel> get parents => List.unmodifiable(_parents);
}
