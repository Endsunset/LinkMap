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
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    //@State private var mapAnnotation: [MKMapItem] = annotations
    @State private var selectedAnnotation: UUID?
    @State private var isShowingSheet = false
    
    @State private var annotationId: Int?
    
    @State private var refreshID = UUID()
    
    @State private var searchText = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State private var locationManager = CLLocationManager()
    
    var body: some View {
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
                    ForEach(annotations) { annotationData in
                        if annotationData.id == selectedAnnotation {
                            PeopleList(isSheet: true, annotationId: annotationData.id)
                                .presentationDetents([.medium, .large])
                                .onDisappear {
                                    selectedAnnotation = nil // Reset selection when sheet dismisses
                                }
                        }
                    }
                    
                }
                .id(refreshID)
                .onAppear {
                    refreshID = UUID()
                    locationManager.requestWhenInUseAuthorization()
                    position = .userLocation(fallback: .automatic)// Force map refresh
                }
            }
            .ignoresSafeArea(.keyboard)

            
            TextField("Search location", text: $searchText, onCommit: geocodeSearchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
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
}

#Preview {
    MapView()
        .modelContainer(SampleData.shared.modelContainer)
}
