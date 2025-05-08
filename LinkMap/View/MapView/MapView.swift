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
    @State private var positionRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    
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
    
    private enum MapStyleType {
        case standard, imagery, hybrid
    }
    
    @State private var mapStyle: MapStyleType = .standard // Initial style matches current .hybrid
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MapReader { proxy in
                    Map(position: $position, bounds: nil, selection: $selectedAnnotation) {
                        UserAnnotation()
                        
                        ForEach(annotations) { annotationData in
                            Marker(annotationData.name, coordinate: CLLocationCoordinate2D(latitude: annotationData.latitude, longitude: annotationData.longitude))
                                .tag(annotationData.id)
                        }
                    }
                    .mapStyle(currentMapStyle)
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
                        NavigationStack {
                            PeopleList(isSheet: true, annotationId: selectedAnnotation)
                                .presentationDetents([.medium, .large])
                        }
                        .navigationBarBackButtonHidden(true)
                        .onDisappear{
                            selectedAnnotation = nil
                        }
                    }
                    .sheet(item: $newAnnotation) { annotationData in
                        NavigationStack {
                            AnnotationDetail(annotation: annotationData, isNew: true, isSheet: true)
                                .presentationDetents([.medium, .large])
                        }
                        .navigationBarBackButtonHidden(true)
                        .interactiveDismissDisabled()
                    }
                    .id(refreshID)
                    .onAppear {
                        refreshID = UUID()
                        locationManager.requestWhenInUseAuthorization()
                        position = .region(positionRegion)
                    }
                }
                .ignoresSafeArea(.keyboard)
                VStack(alignment: .leading) {
                    VStack {
                        Button {
                            isAddingEnabled.toggle()
                        } label: {
                            SquareButtonLabel(systemName: isAddingEnabled ? "mappin" : "mappin.slash")
                                .padding(.vertical)
                        }
                        
                        Button {
                            switch mapStyle {
                            case .standard:
                                mapStyle = .imagery
                            case .imagery:
                                mapStyle = .hybrid
                            case .hybrid:
                                mapStyle = .standard
                            }
                        } label: {
                            SquareButtonLabel(systemName: "map")
                        }
                    }
                    .padding(.horizontal)
                    
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
    
    private var currentMapStyle: MapStyle {
            switch mapStyle {
            case .standard:
                return MapStyle.standard(elevation: .realistic)
            case .imagery:
                return MapStyle.imagery(elevation: .realistic)
            case .hybrid:
                return MapStyle.hybrid(elevation: .realistic)
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
