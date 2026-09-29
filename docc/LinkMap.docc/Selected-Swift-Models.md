# Selected Swift Models

These internal LinkMap-core declarations support the conceptual and implementation guides. They are not a public SDK contract.

## `ProjectModel`

`ProjectModel` wraps the Project record. `recordID` is stable identity, `name` is editable, `restoreFieldsFromRecord()` discards unsaved edits, and `toCKRecord()` prepares a baseline-preserving record for save. Source: `LinkMap/Models/CKRecord/ProjectModel.swift`.

```swift
func restoreFieldsFromRecord()
func toCKRecord() -> CKRecord
```

## `ActivityModel`

`ActivityModel` represents one Project work cycle. `isArchived` is true when a loaded Activity record has no parent. `toCKRecord(parentProjectID:)` writes the Project reference and parent for active Activities. Source: `LinkMap/Models/CKRecord/ActivityModel.swift`.

```swift
var isArchived: Bool { get }
func toCKRecord(parentProjectID: CKRecord.ID? = nil) -> CKRecord
```

## `LocationModel`

`LocationModel` carries a coordinate, optional Region and Layer references, and optional area vertices. `restoreFieldsFromRecord()` restores an edited model from the loaded record; `applyFields(to:)` writes its values to a record. Source: `LinkMap/Models/CKRecord/LocationModel.swift`.

```swift
func restoreFieldsFromRecord()
func applyFields(to record: CKRecord)
```

## `TransactionModel`

`TransactionModel` holds the Item, optional source and destination, quantity, and note for one resource movement. `createdAt` and `modifiedAt` come from CloudKit metadata. `applyFields(to:)` writes its fields; flow validation belongs to the owning workflow. Source: `LinkMap/Models/CKRecord/TransactionModel.swift`.

```swift
func restoreFieldsFromRecord()
func applyFields(to record: CKRecord)
```
