//
//  AnnotationDetail.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/14.
//

import SwiftUI
import SwiftData
import MapKit

struct AnnotationDetail: View {
    @Query(sort: \AnnotationData.id) private var annotations: [AnnotationData]
    @Bindable var annotation: AnnotationData
    let isNew: Bool
    let isSheet: Bool
    @Environment(\.modelContext) private var context
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var position: MapCameraPosition
    
    @State private var locationManager = CLLocationManager()
    
    init(annotation: AnnotationData, isNew: Bool = false, isSheet: Bool = false) {
        self.annotation = annotation
        self.isNew = isNew
        self.isSheet = isSheet
        self.position = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    }
    
    var body: some View {
        VStack {
            if !isSheet {
                MapReader { proxy in
                    Map(position: $position) {
                        UserAnnotation()
                        
                        ForEach(annotations) { annotationData in
                            if annotationData.id != annotation.id {
                                Marker("", coordinate: CLLocationCoordinate2D(latitude: annotationData.latitude, longitude: annotationData.longitude))
                            }
                        }
                        
                        Marker(annotation.name == "" ? "Untitled Annotation" : annotation.name, coordinate: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude))
                    }
                    .onTapGesture { screenPoint in
                        if let markerLocation = proxy.convert(screenPoint, from: .local) {
                            annotation.latitude = markerLocation.latitude
                            annotation.longitude = markerLocation.longitude
                        }
                    }
                }
            }
            
            Form {
                TextField("Name", text: $annotation.name)
                    .autocorrectionDisabled()
                TextField("Detail", text: $annotation.detail)
                NavigationLink("Groups") {
                    PeopleList(annotationId: annotation.id)
                }
            }
        }
        .navigationTitle(isNew ? "New Annotation" : "Annotation")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: annotation) { _, _ in  // Saves when ANY property changes
            save()
        }
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
        }
        .onDisappear { //  Save when navigating back
            save()
        }
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        context.delete(annotation)
                        save()
                        dismiss()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(isNew)
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            
        }
    }
}

#Preview {
    AnnotationDetail(annotation: AnnotationData())
}
