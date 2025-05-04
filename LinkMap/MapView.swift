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
    @Environment(\.modelContext) private var context
    
    @State private var position: MapCameraPosition = .automatic
    
    //@State private var mapAnnotation: [MKMapItem] = annotations
    @State private var selectedAnnotation: UUID?
    @State private var isShowingSheet = false
    
    @State private var annotationId: Int?
    
    @State private var refreshID = UUID()
    
    @State private var searchText = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State private var locationManager = CLLocationManager()
    
    @State private var newAnnotation: AnnotationData?
    @State private var isAddingEnabled = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MapReader { proxy in
                    Map(position: $position, selection: $selectedAnnotation) {
                        UserAnnotation()
                        
                        ForEach(annotations) { annotationData in
                            Marker(annotationData.name, coordinate: CLLocationCoordinate2D(latitude: annotationData.latitude, longitude: annotationData.longitude))
                                .tag(annotationData.id)
                        }
                    }
                    .mapStyle(.hybrid(elevation: .realistic))
                    .onTapGesture { screenPoint in
                        if isAddingEnabled {
                            if let markerLocation = proxy.convert(screenPoint, from: .local) {
                                addAnnotationData(longitude: markerLocation.longitude, latitude: markerLocation.latitude)
                            }
                        }
                    }
                    .onChange(of: annotations) {
                        position = .userLocation(fallback: .automatic)
                    }
                    .onChange(of: selectedAnnotation) { _, newValue in
                        if newValue != nil {
                            isShowingSheet = true // Trigger sheet when annotation is selected
                        }
                    }
                    .mapControls {
                        MapUserLocationButton()
                        MapCompass()
                        MapScaleView()
                    }
                    .sheet(isPresented: $isShowingSheet) {
                        NavigationStack {
                            PeopleList(isSheet: true, annotationId: selectedAnnotation)
                                .presentationDetents([.medium, .large])
                        }
                    }
                    .sheet(item: $newAnnotation) { annotationData in
                        NavigationStack {
                            AnnotationDetail(annotation: annotationData, isNew: true)
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .interactiveDismissDisabled()
                    }
                    .id(refreshID)
                    .onAppear {
                        refreshID = UUID()
                        locationManager.requestWhenInUseAuthorization()
                        position = .automatic// Force map refresh
                    }
                }
                .ignoresSafeArea(.keyboard)
                VStack(alignment: .leading) {
                    Button("Add Annotation") {
                        isAddingEnabled.toggle()
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    
                    HStack {
                        TextField("Search location", text: $searchText, onCommit: geocodeSearchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .submitLabel(.done)
                            .onSubmit {
                                
                            }
                    }
                    .padding()
                }
            }
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
        let newAnnotation = AnnotationData(name: "New annotation", longitude: longitude, latitude: latitude)
        context.insert(newAnnotation)
        self.newAnnotation = newAnnotation
    }
    
    private func deleteAnnotation(indexes: IndexSet) {
        for index in indexes {
            context.delete(annotations[index])
        }
    }
}

#Preview {
    MapView()
        .modelContainer(SampleData.shared.modelContainer)
}
