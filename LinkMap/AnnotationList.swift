//
//  AnnotationList.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/13.
//

import SwiftUI
import SwiftData

struct AnnotationList: View {
    @Query(sort: \AnnotationData.annotationId) private var annotations: [AnnotationData]
    @Environment(\.modelContext) private var context
    @State private var newAnnotation: AnnotationData?
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(annotations) { annotationData in
                    NavigationLink(annotationData.name) {
                        AnnotationDetail(annotation: annotationData)
                        
                    }
                }
                .onDelete(perform: deleteAnnotation(indexes:))
            }
            .navigationTitle("Annotations")
            .toolbar {
                ToolbarItem {
                    Button("Add annotation", systemImage: "plus", action: addAnnotation)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .sheet(item: $newAnnotation) { annotationData in
                NavigationStack {
                    AnnotationDetail(annotation: annotationData, isNew: true)
                }
                .interactiveDismissDisabled()
            }
        } detail: {
            Text("Select an annotation")
                .navigationTitle("Annotation")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addAnnotation() {
        let newAnnotation = AnnotationData(annotationId: 1, name: "New annotation", longitude: 0.0, latitude: 0.0)
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
