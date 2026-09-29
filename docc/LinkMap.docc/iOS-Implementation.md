# iOS Implementation

The native app is a SwiftUI application backed by private and shared CloudKit Project data. MapKit renders the selected Project context. Domain-specific CloudKit helpers handle persistence, while views own the data they display.

The implementation notes below describe boundaries and workflows, not every internal symbol.

## Topics

### App Structure

- <doc:SwiftUI-Architecture>
- <doc:iOS-CloudKit>
- <doc:iOS-MapKit>

### Resource Work

- <doc:Resource-Workflows>
