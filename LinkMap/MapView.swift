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

struct MapView: View {
    @Query private var annotations: [AnnotationData]
    @Environment(\.modelContext) private var context
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    //@State private var mapAnnotation: [MKMapItem] = annotations
    @State private var selectedAnnotation: UUID?
    @State private var isShowingSheet = false
    
    @State private var annotationId: Int?
    
    @State private var refreshID = UUID()
    
    var body: some View {
        ZStack(alignment: .top) {
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
                
            }
            .sheet(isPresented: $isShowingSheet) {
                /*
                if let annotation = annotations.first(where: { $0.id == selectedAnnotation }) {
                    NavigationStack {
                        PeopleList(isSheet: true, annotationId: annotation.id)
                            .navigationTitle("People")
                            .navigationBarBackButtonHidden(true) // Hide back button
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button("Done") {
                                        isShowingSheet = false // Dismiss sheet
                                    }
                                }
                            }
                    }
                    .onDisappear {
                        selectedAnnotation = nil // Reset selection
                    }
                }
                 */
                
                ForEach(annotations) { annotationData in
                    if annotationData.id == selectedAnnotation {
                        PeopleList(isSheet: true, annotationId: annotationData.id)
                            .onDisappear {
                                selectedAnnotation = nil // Reset selection when sheet dismisses
                            }
                    }
                }
                 
            }
            .id(refreshID)
            .onAppear {
                refreshID = UUID()  // Force map refresh
            }
        }
    }
}

#Preview {
    MapView()
        .modelContainer(SampleData.shared.modelContainer)
}
