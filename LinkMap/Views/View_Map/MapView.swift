//
//  AnnotationView.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/15.
//

import SwiftUI
import SwiftData
import MapKit
import CoreLocation
import Combine

struct MapView: View {
    @Query private var annotations: [AnnotationData]
    @Query private var people: [Person]
    @Environment(\.modelContext) private var context
    
    @State private var position: MapCameraPosition = .automatic
    @State private var positionRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    
    //@State private var mapAnnotation: [MKMapItem] = annotations
    @State private var selectedAnnotation: AnnotationData?
    @State private var isShowingSheet = false
    
    @State private var annotationId: Int?
    
    @State private var refreshID = UUID()
    
    @State private var searchText = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State private var locationManager = CLLocationManager()
    
    @State private var newAnnotation: AnnotationData?
    @State private var newPerson: Person?
    @State private var isAddingEnabled = false
    
    public enum MapStyleType {
        case standard, imagery, hybrid
    }
    
    @State private var mapStyle: MapStyleType = .standard
    
    @State private var path = NavigationPath()
    
    @State private var displayed = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MapReader { proxy in
                    Map(position: $position, bounds: nil, selection: $selectedAnnotation) {
                        UserAnnotation()
                        
                        ForEach(annotations) { annotationData in
                            Marker(annotationData.name == "" ? "Untitled Annotation" : annotationData.name, coordinate: CLLocationCoordinate2D(latitude: annotationData.latitude, longitude: annotationData.longitude))
                                .tag(annotationData)
                        }
                    }
                    .mapStyle(currentMapStyle)
                    .id(refreshID)
                    .onTapGesture { screenPoint in
                        if isAddingEnabled {
                            if let markerLocation = proxy.convert(screenPoint, from: .local) {
                                addAnnotationData(longitude: markerLocation.longitude, latitude: markerLocation.latitude)
                            }
                        }
                    }
                    .onMapCameraChange { context in
                        positionRegion = context.region
                    }
                    .onChange(of: annotations) {
                        position = .region(positionRegion)
                    }
                    .onChange(of: selectedAnnotation) { _, newValue in
                        if !isAddingEnabled {
                            if newValue != nil {
                                isShowingSheet = true // Trigger sheet when annotation is selected
                            }
                        } else {
                            selectedAnnotation = nil
                        }
                    }
                    .mapControls {
                        MapUserLocationButton()
                        MapCompass()
                        MapPitchToggle()
                        MapScaleView()
                    }
                    .sheet(isPresented: $isShowingSheet) {
                        NavigationStack(path: $path) {
                            Text("Loading...")
                                .navigationDestination(for: String.self) { _ in
                                    MapPanel(annotation: selectedAnnotation)
                                }
                                .onAppear {
                                    if displayed {
                                        displayed = false
                                        isShowingSheet = false
                                    } else {
                                        displayed = true
                                        path.append("")
                                    }
                                }
                        }
                        .presentationDetents([.medium, .large])
                        .onDisappear{
                            selectedAnnotation = nil
                            position = .region(positionRegion)
                            refreshID = UUID()
                        }
                    }
                    .sheet(item: $newAnnotation) { annotationData in
                        //Resolve the unexpected toolbar item from documentgroup toolbar
                        NavigationStack(path: $path) {
                            Text("Loading...")
                                .navigationDestination(for: String.self) { _ in
                                    AnnotationDetail(annotation: annotationData, isNew: true, isSheet: true)
                                }
                                .onAppear {
                                    if displayed {
                                        displayed = false
                                        newAnnotation = nil
                                    } else {
                                        displayed = true
                                        path.append("")
                                    }
                                }
                        }
                        .presentationDetents([.medium, .large])
                        .interactiveDismissDisabled()
                    }
                    .onAppear {
                        isAddingEnabled = false
                        refreshID = UUID()
                        locationManager.requestWhenInUseAuthorization()
                    }
                }
                .ignoresSafeArea(.keyboard)
                VStack(alignment: .leading) {
                    MapToolBar(
                        isAddingEnabled: $isAddingEnabled,
                        mapStyle: $mapStyle
                    )
                    
                    SearchBarView(searchText: $searchText, onCommit: geocodeSearchText)
                        .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink("Help") {
                        NavigationStack {
                            Help()
                        }
                    }
                }
            }
        }
    }
    
    private var currentMapStyle: MapStyle {
        switch mapStyle {
        case .standard:
            return MapStyle.standard
        case .imagery:
            return MapStyle.imagery
        case .hybrid:
            return MapStyle.hybrid
        }
    }
    
    private func geocodeSearchText() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchText) { placemarks, error in
            if let error = error {
                alertMessage = "Geocoding error: \(error.localizedDescription)"
                showingAlert = true
                return
            }
            
            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                alertMessage = "Location not found"
                showingAlert = true
                return
            }
            
            position = .region(MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            ))
        }
    }
    
    private func addAnnotationData(longitude: Double,latitude: Double) {
        let newAnnotation = AnnotationData(name: "", longitude: longitude, latitude: latitude)
        context.insert(newAnnotation)
        self.newAnnotation = newAnnotation
    }
    
    private func deleteAnnotation(indexes: IndexSet) {
        for index in indexes {
            context.delete(annotations[index])
        }
    }
    private func addPerson(name: String, id: UUID?) {
        let newPerson = Person(name: name, photo: "", requirement: "", statue: false, annotationId: id)
        context.insert(newPerson)
        self.newPerson = newPerson
    }
    
    private func deletePeople(indexes: IndexSet) {
        for index in indexes {
            context.delete(people[index])
        }
    }
}

#Preview {
    MapView()
        .modelContainer(for: [AnnotationData.self, Person.self])
}
