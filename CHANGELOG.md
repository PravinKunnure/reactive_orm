# Changelog

All notable changes to this project will be documented in this file.

This project follows **Semantic Versioning**.

---

## [0.0.4] - 2025-12-26
### Added
- In README for better documentation and examples
- Clarified `model.field = newValue (auto-notifies)` syntax in docs
- Improved README structure, highlighting object-wise, field-wise, Many → One, and Many ↔ Many patterns
- Updated GIF demo to match current patterns

### Improved
- Documentation clarity: emphasized which fields trigger rebuilds
- Polished example app to better showcase reactive patterns
- Minor code refactoring in example to optimize field setters and `addNested` usage

### Notes
- Still experimental/alpha
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
- Still an **early alpha**
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

### Notes
- Experimental alpha release
- Persistence and advanced ORM features not yet implemented
