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
    
    @State private var editMode = EditMode.inactive
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var path = NavigationPath()
    
    @State private var displayed = false
    
    var body: some View {
        List {
            ForEach(annotations) { annotationData in
                NavigationLink(annotationData.name == "" ? "Untitled Annotation" : annotationData.name) {
                    AnnotationDetail(annotation: annotationData)
                }
            }
            .onDelete(perform: deleteAnnotation(indexes:))
        }
        .navigationTitle("Annotations")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if editMode.isEditing {
                    Button("Done") {
                        editMode = .inactive
                    }
                } else {
                    Menu("Options") {
                        Button("Add Annotation", systemImage: "plus", action: addAnnotationData)
                        
                        Button {
                            editMode = .active
                        } label: {
                            Text("Edit")
                            Image(systemName: "pencil")
                        }
                        
                        NavigationLink {
                            HelpView()
                        } label: {
                            Text("Help")
                            Image(systemName: "questionmark.circle")
                        }
                    }
                }
            }
        }
        .environment(\.editMode, $editMode)
        .sheet(item: $newAnnotation) { annotationData in
            NavigationStack(path: $path) {
                Text("Loading...")
                    .navigationDestination(for: String.self) { _ in
                        AnnotationDetail(annotation: annotationData, isNew: true)
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
            .interactiveDismissDisabled()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addAnnotationData() {
        let newAnnotation = AnnotationData(name: "", longitude: center.longitude, latitude: center.latitude)
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
        .modelContainer(for: [AnnotationData.self, Person.self])
}
