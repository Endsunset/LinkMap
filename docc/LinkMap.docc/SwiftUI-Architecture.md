# SwiftUI Architecture

`MapView` is the app's primary route. It owns map presentation, the selected Project/Activity/Assignment context, and the coordination of Dashboard, creation, scanner, style, and Location detail sheets. `MapContextController` keeps the three selections consistent: changing Project clears Activity and Assignment; changing Activity clears Assignment.

`MapViewModel` owns map state such as camera, visible Locations, route overlays, and editing sessions. Project and Activity list/detail views own their displayed arrays and refresh them through the matching CloudKit helper. `ProjectDetail` provides the Project browser and its current selections. This keeps state close to the screen that presents it.

When an edit starts, a model's loaded record is the baseline. Save persists the edited copy and replaces that baseline only after CloudKit accepts it; Cancel restores the stored values. See `UX.md`, `WORKFLOW.md`, `LinkMap/Views/Map/MapView.swift`, and `LinkMap/Utilities/Model/MapContextController.swift` in LinkMap-core.
