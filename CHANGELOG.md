# Changelog

All notable changes to this project will be documented in this file.

This project follows **Semantic Versioning**.

---

## [1.0.1] - 2025-12-31
### Added
- Optional debug tracing in ReactiveModel with debugNotify flag for development.
- Nested model propagation refined: addNested() now supports optional field to notify only relevant listeners.
- Improved lifecycle handling: ReactiveBuilder and ReactiveSelector now handle model replacement safely.
- ReactiveSelector rebuilds only when selected value changes (equality check).

### Changed
- ReactiveBuilder and ReactiveSelector listener management updated to avoid duplicate or unnecessary rebuilds.
- Documentation updated to explain debug tracing and nested propagation options.
- Examples revised to demonstrate new debug tracing and nested field propagation features.

### Fixed
- Prevented multiple rebuilds caused by nested model updates.
- Fixed subtle bugs in ReactiveSelector when model or field changed.
- Ensured ReactiveBuilder is lifecycle-safe and rebuilds correctly on model replacement.

### Notes
- Fully backward-compatible with previous v1.0.0 API.
- Debug tracing is optional and disabled by default.
- Nested propagation refinement allows field-aware rebuilds for large model graphs.

---

## [1.0.0] - 2025-12-30
### Added
- Official release: **Reactive Object–Relationship Model** (v1.0.0)
- Fully Symbol-based field notifications (`#title`, `#completed`, `#status`) for safer, typo-proof updates.
- Field-wise `ReactiveBuilder` updated to support Symbols.
- Nested model support improved; `addNested()` handles multiple nested models safely.
- Relationship patterns formalized: Many → One, Many ↔ Many.
- Example app updated to demonstrate Symbol-based fields and relationship patterns.
- Debug logging added to indicate widget rebuilds.

### Changed
- Task model setters now notify listeners using **Symbols** instead of strings.
- ReactiveSelector and ReactiveBuilder updated to handle Symbol fields consistently.
- Documentation revised for clarity: README now emphasizes **Reactive Object–Relationship Model**, not database ORM.
- Mental model clarified: object graph + relationships drive UI updates.
- Backward compatibility: string-based field notifications still supported, but Symbols are recommended.

### Fixed
- Resolved potential multiple rebuild issues when multiple fields change in nested models.
- Fixed minor typos in `ReactiveBuilder.fields` usage in example.

### Notes
- v1.0.0 is stable and suitable for prototyping and production-level Flutter apps using complex reactive domain models.
- Object-wise, field-wise, Many → One, and Many ↔ Many reactivity patterns remain fully supported.
- Batch updates, async persistence hooks, and optional code generation remain on roadmap.


## [0.0.9] - 2025-12-30
### Added
- Field notification with Symbol
- Safer and typo-proof alternative to string field names (#title, #completed, #status).
- Field-wise ReactiveBuilder updated to support Symbols.
- Nested model support improved
- addNested() now handles multiple nested models safely.

###Changed
- Task model setters now notify listeners using Symbols instead of strings.
- Example app updated to showcase Symbol-based field notifications.
- Debug logging added to clearly show which widgets rebuild.

### Fixed
- Fixed potential rebuild issues when multiple fields change in nested models.
- Fixed minor typo in example: field names in ReactiveBuilder.fields.

### Notes
- This release maintains backward compatibility with string-based field notifications, but Symbol-based fields are now recommended.
- Object-wise, field-wise, Many → One, and Many ↔ Many reactivity patterns remain fully supported.


## [0.0.7] - 2025-12-29
### Added
- Formalized the meaning of **ORM** as **Reactive Object–Relationship Model**
- Clear separation in documentation of what `reactive_orm` **is** and **is not**
- Explicit positioning as a **field-level state management solution**
- Documented relationship-driven reactivity (Many → One, Many ↔ Many)
- Improved high-level explanation of object-wise vs field-wise reactivity

### Improved
- README rewritten for clarity, scalability, and pub.dev discoverability
- Examples refined to highlight real-world domain modeling patterns
- Comparison table polished to better differentiate from `ValueNotifier`
- Overall package messaging aligned for medium-to-large Flutter apps

### Notes
- No breaking API changes
- Focused on conceptual clarity and long-term positioning

---

## [0.0.6] - 2025-12-29
### Added
- Updated README to justify `reactive_orm` name as **Object Reactive Model**
- Emphasized **field-level reactivity**, **object-wise reactivity**, and **nested/shared model patterns**
- Clarified ORM-style mental model: models behave like domain entities but are purely in-memory
- Added explicit explanation: what the package **is** and **is not**
- Updated example usage for field-wise and object-wise reactivity

### Improved
- Improved documentation structure for better readability and clarity
- Updated GIF demo to showcase field-wise and nested model updates
- Polished comparison table with ValueNotifier for clearer differentiation

---

## [0.0.5] - 2025-12-26
### Added
- Improved README structure, highlighting object-wise, field-wise, Many → One, and Many ↔ Many patterns
- Updated GIF demo to match current patterns (GIF size optimized for pub.dev)

---

## [0.0.4] - 2025-12-26
### Added
- Better documentation and examples in README
- Clarified `model.field = newValue` (auto-notifies) syntax
- Highlighted object-wise, field-wise, Many → One, and Many ↔ Many patterns
- Updated GIF demo to match current patterns

### Improved
- Documentation clarity: emphasized which fields trigger rebuilds
- Polished example app to better showcase reactive patterns
- Minor code refactoring in example to optimize field setters and `addNested` usage

### Notes
- Still experimental / alpha
- APIs remain stable but may evolve based on user feedback

---

## [0.0.3] - 2025-12-24
### Added
- Field-wise reactivity via `ReactiveBuilder(fields: [...])`
- Selective widget rebuilds based on changed model fields
- Support for nested reactive models using `addNested`
- Many → One and Many ↔ Many reactive relationships

### Improved
- Optimized notification and listener dispatch
- Reduced unnecessary widget rebuilds
- Cleaner internal callback handling

### Notes
- Early alpha
- APIs may change based on feedback

---

## [0.0.2] - 2025-12-24
### Added
- Internal support for field-level change notifications
- Model property setters can now notify by field name
- Foundation for selective reactivity (used in 0.0.3)

### Improved
- Performance optimizations in listener handling
- Reduced redundant rebuild triggers

### Notes
- Field-wise reactivity not exposed publicly yet
- Transitional internal release

---

## [0.0.1] - 2025-12-24
### Added
- Initial release of `reactive_orm`
- `ReactiveModel` base class for reactive data models
- `ReactiveBuilder` widget for automatic UI updates
- Object-wise reactivity (whole model rebuilds)
- Multiple widgets can observe the same model instance
- Basic Flutter integration example
