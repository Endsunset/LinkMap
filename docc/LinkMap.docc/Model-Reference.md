# Selected Model Reference

These selected native model declarations clarify the records behind the conceptual guides. They are internal implementation types, not a public SDK contract. This curated reference intentionally does not publish every symbol discovered in the app target.

## `ProjectModel`

`ProjectModel` is an observable, identifiable wrapper for a Project record. `recordID` provides stable identity, `name` is editable, `restoreFieldsFromRecord()` discards unsaved name edits, and `toCKRecord()` creates a baseline-preserving record for save. Source: `LinkMap/Models/CKRecord/ProjectModel.swift` in LinkMap-core.

## `ActivityModel`

`ActivityModel` records the Project’s work cycle. Its `isArchived` property is true when a loaded Activity record has no parent. `toCKRecord(parentProjectID:)` writes the Project reference and parent relationship for active Activities. Source: `LinkMap/Models/CKRecord/ActivityModel.swift` in LinkMap-core.

## `TransactionModel`

`TransactionModel` carries `itemReference`, optional `fromReference` and `toReference`, positive `quantity`, and `note`. `createdAt` and `modifiedAt` come from CloudKit record metadata. `applyFields(to:)` writes mutable fields to a record; flow validation and directional uniqueness are handled by the owning CloudKit workflow. Source: `LinkMap/Models/CKRecord/TransactionModel.swift` in LinkMap-core.
