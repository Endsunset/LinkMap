//
//  AnnotationList.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/13.
//

import SwiftUI
import SwiftData
import MapKit

let center = CLLocationCoordinate2D(latitude: 35.8617, longitude: 104.1954)

struct AnnotationList: View {
    @Query(sort: \AnnotationData.id) private var annotations: [AnnotationData]
    @Environment(\.modelContext) private var context
    @State private var newAnnotation: AnnotationData?
    
    @StateObject private var locationManager = LocationManager()
    
    
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(annotations) { annotationData in
                    NavigationLink(annotationData.name) {
                        AnnotationDetail(annotation: annotationData)
                    }
                    .navigationBarTitleDisplayMode(.inline)
                }
                .onDelete(perform: deleteAnnotation(indexes:))
            }
            .navigationTitle("Annotations")
            .toolbar {
                ToolbarItem {
                    Button("Add annotation", systemImage: "plus", action: addAnnotationData)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .sheet(item: $newAnnotation) { annotationData in
                NavigationStack {
                    AnnotationDetail(annotation: annotationData, isNew: true)
                }
                .navigationBarTitleDisplayMode(.inline)
                .interactiveDismissDisabled()
            }
        } detail: {
            Text("Select an annotation")
                .navigationTitle("Annotation")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    private func addAnnotationData() {
        let newAnnotation = AnnotationData(name: "New annotation", longitude: locationManager.userLocation?.longitude ?? center.latitude, latitude: locationManager.userLocation?.latitude ?? center.latitude)
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
    AnnotationList()
        .modelContainer(SampleData.shared.modelContainer)
}
