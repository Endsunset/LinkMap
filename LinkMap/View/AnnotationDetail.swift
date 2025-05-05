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
    @Bindable var annotation: AnnotationData
    let isNew: Bool
    @Environment(\.modelContext) private var context
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var position: MapCameraPosition = .automatic
    
    @State private var locationManager = CLLocationManager()
    
    init(annotation: AnnotationData, isNew: Bool = false) {
        self.annotation = annotation
        self.isNew = isNew
    }
    
    var body: some View {
        VStack {
            MapReader { proxy in
                Map(position: $position) {
                    UserAnnotation()
                    
                    Marker(annotation.name, coordinate: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude))
                }
                .onTapGesture { screenPoint in
                    if let markerLocation = proxy.convert(screenPoint, from: .local) {
                        annotation.latitude = markerLocation.latitude
                        annotation.longitude = markerLocation.longitude
                    }
                }
            }
            
            Form {
                TextField("Name", text: $annotation.name)
                    .autocorrectionDisabled()
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
    NavigationStack {
        AnnotationDetail(annotation: SampleData.shared.annotation)
    }
}

#Preview("New Friend") {
    NavigationStack {
        AnnotationDetail(annotation: SampleData.shared.annotation, isNew: true)
    }
}
