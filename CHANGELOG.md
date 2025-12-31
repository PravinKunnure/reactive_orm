# Changelog

All notable changes to this project will be documented in this file.

This project follows **Semantic Versioning**.

---

## [1.1.0] - 2026-01-XX
### Added
- Reaction utilities for side effects (`reaction`, `when`, `listen`) without widget rebuilds.
- Lightweight computed field helpers for derived values based on reactive models.
- Enhanced debug tracing with structured logs for field, object, and nested updates.
- Developer tooling hooks to inspect nested propagation chains.
- Large-app architecture guidance and examples (dashboards, computed metrics, reactions).

### Improved
- Developer experience for complex object graphs and shared domain models.
- Observability of reactive flows in large widget trees.
- Documentation expanded to clarify scaling patterns and best practices.

### Notes
- No breaking API changes.
- Designed to improve maintainability and observability in medium-to-large apps.
- All features are optional and opt-in.

---

## [1.0.1] - 2025-12-31
### Added
- Optional debug tracing in `ReactiveModel` with `debugNotify` flag for development.
- Nested model propagation refined: `addNested()` now supports optional field to notify only relevant listeners.
- Improved lifecycle handling: `ReactiveBuilder` and `ReactiveSelector` now handle model replacement safely.
- `ReactiveSelector` rebuilds only when selected value changes (equality check).

### Changed
- `ReactiveBuilder` and `ReactiveSelector` listener management updated to avoid duplicate or unnecessary rebuilds.
- Documentation updated to explain debug tracing and nested propagation options.
- Examples revised to demonstrate new debug tracing and nested field propagation features.

### Fixed
- Prevented multiple rebuilds caused by nested model updates.
- Fixed subtle bugs in `ReactiveSelector` when model or field changed.
- Ensured `ReactiveBuilder` is lifecycle-safe and rebuilds correctly on model replacement.

### Notes
- Fully backward-compatible with previous v1.0.0 API.
- Debug tracing is optional and disabled by default.
- Nested propagation refinement allows field-aware rebuilds for large model graphs.

---

## [1.0.0] - 2025-12-30
### Added
- Official release: **Reactive Object–Relationship Model** (v1.0.0).
- Fully Symbol-based field notifications (`#title`, `#completed`, `#status`) for safer, typo-proof updates.
- Field-wise `ReactiveBuilder` updated to support Symbols.
- Nested model support improved; `addNested()` handles multiple nested models safely.
- Relationship patterns formalized: Many → One, Many ↔ Many.
- Example app updated to demonstrate Symbol-based fields and relationship patterns.
- Debug logging added to indicate widget rebuilds.

### Changed
- Task model setters now notify listeners using **Symbols** instead of strings.
- `ReactiveSelector` and `ReactiveBuilder` updated to handle Symbol fields consistently.
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

---

## [0.0.9] - 2025-12-30
### Added
- Field notification with Symbols.
- Safer and typo-proof alternative to string field names (`#title`, `#completed`, `#status`).
- Field-wise `ReactiveBuilder` updated to support Symbols.
- Nested model support improved; `addNested()` now handles multiple nested models safely.

### Changed
- Task model setters now notify listeners using Symbols instead of strings.
- Example app updated to showcase Symbol-based field notifications.
- Debug logging added to clearly show which widgets rebuild.

### Fixed
- Fixed potential rebuild issues when multiple fields change in nested models.
- Fixed minor typo in example: field names in `ReactiveBuilder.fields`.

### Notes
- Backward-compatible with string-based field notifications.
- Symbol-based fields are now recommended.

---

## [0.0.7] - 2025-12-29
### Added
- Formalized **ORM** as **Reactive Object–Relationship Model**.
- Clear separation of what `reactive_orm` **is** and **is not**.
- Explicit positioning as a **field-level state management solution**.
- Documented relationship-driven reactivity (Many → One, Many ↔ Many).

### Improved
- README rewritten for clarity and pub.dev discoverability.
- Examples refined to highlight real-world domain modeling patterns.
- Comparison table polished to better differentiate from `ValueNotifier`.

### Notes
- No breaking API changes.

---

## [0.0.6] - 2025-12-29
### Added
- Clarified ORM-style mental model: in-memory reactive domain entities.
- Expanded documentation for object-wise and field-wise reactivity.
- Updated examples to reflect nested/shared model usage.

### Improved
- Documentation structure and clarity.
- Demo visuals updated.

---

## [0.0.5] - 2025-12-26
### Added
- Improved README structure.
- Updated GIF demo (optimized for pub.dev).

---

## [0.0.4] - 2025-12-26
### Added
- Better documentation and examples.
- Highlighted object-wise, field-wise, and relationship patterns.

### Improved
- Example app polished for clarity and correctness.

---

## [0.0.3] - 2025-12-24
### Added
- Field-wise reactivity via `ReactiveBuilder(fields: [...])`.
- Nested reactive models using `addNested`.
- Many → One and Many ↔ Many relationships.

---

## [0.0.2] - 2025-12-24
### Added
- Internal field-level change notification support.

---

## [0.0.1] - 2025-12-24
### Added
- Initial release of `reactive_orm`.
- `ReactiveModel` base class.
- `ReactiveBuilder` widget.
- Object-wise reactivity.
