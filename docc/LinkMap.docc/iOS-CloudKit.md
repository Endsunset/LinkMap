# CloudKit on iOS

Each Project is the root of one private or shared CloudKit hierarchy in a custom `projectZone-*` zone. A Project share grants collaborators access to its active child records. `CKUtility` extensions divide read and write work by domain: Project, Location, Activity, Route, Assignment, Transaction, and sharing.

The private and shared databases remain separate. Views fetch the records they need through the appropriate helper and reconcile saved records by identity. `ProjectSyncEngine` coordinates long-lived private/shared change tracking; it does not replace normal view refreshes after edits.

Loaded `CKRecord` values act as save baselines. Existing edits use a baseline-preserving copy and surface a conflict rather than silently overwriting a newer server record. See `ARCHITECTURE.md`, `LinkMap/Utilities/CKUtility/`, and `LinkMap/Utilities/ProjectSync/` in LinkMap-core.
