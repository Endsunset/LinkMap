# MapKit on iOS

`MapView` uses SwiftUI's MapKit `Map` and `MapReader`. `MapViewModel` supplies the camera, Project Locations, selected Activity routes, Assignment filtering, and the current editing state.

The map can show a Project without an Activity. Selecting an Activity adds its route overlays; selecting an Assignment narrows the visible route and Locations. Region and Layer context determines which places and areas are in view. Location relocation and area editing use a map editing session: interactions update a draft, Save persists it, and Cancel restores the stored record.

Search and selection are map-owned so choosing a place does not rewrite Project data. See `LinkMap/Views/Map/MapView.swift`, `LinkMap/Utilities/Model/MapViewModel.swift`, and `LinkMap/Utilities/Model/MapEditingSession.swift` in LinkMap-core.
