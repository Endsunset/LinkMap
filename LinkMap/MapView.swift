//
//  AnnotationView.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/15.
//

import SwiftUI
import SwiftData
import MapKit

struct MapView: View {
    @Query private var annotations: [AnnotationData]
    @Environment(\.modelContext) private var context
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    //@State private var mapAnnotation: [MKMapItem] = annotations
    @State private var selectedAnnotation: String?
    @State private var isShowingSheet = false
    
    @State private var annotationId: Int?
    
    @State private var refreshID = UUID()
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $position, selection: $selectedAnnotation) {
                UserAnnotation()
                
                ForEach(annotations) { annotationData in
                    Marker(annotationData.name, coordinate: CLLocationCoordinate2D(latitude: annotationData.latitude, longitude: annotationData.longitude))
                        .tag(annotationData.name)
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
                ForEach(annotations) { annotationData in
                    if annotationData.name == selectedAnnotation {
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
