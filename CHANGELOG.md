# Changelog

All notable changes to this project will be documented in this file.

This project follows **Semantic Versioning**.

---

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
