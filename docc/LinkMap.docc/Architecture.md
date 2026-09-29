# Architecture

LinkMap uses private and shared CloudKit databases with one `projectZone-*` zone and one Project share root per Project.

## Record Ownership

```text
Project
├── Region, Layer, Location
├── Item, Inventory, Project Transaction
└── Activity
    ├── Assignment
    ├── Route → Stop
    └── Activity Transaction
```

The Project foundation is reusable. Activity children describe one work cycle. Transactions are parented according to their endpoints and carry an Item, positive quantity, optional source and destination, note, and Project reference. Endpoint references do not change record ownership.

## State Boundaries

The Map owns map context, selection, editing, and camera state. List and detail views own their displayed data and refresh through the matching CloudKit utility. Loaded model records serve as the baseline for edits; saving preserves that baseline until CloudKit accepts the change.

For implementation details, consult `ARCHITECTURE.md` in the native LinkMap-core repository.

- <doc:Model-Reference>
