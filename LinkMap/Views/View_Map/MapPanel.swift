//
//  MapPanel.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/10.
//

import SwiftUI
import SwiftData

struct MapPanel: View {
    @Query private var annotations: [AnnotationData]
    @Environment(\.modelContext) private var context
    
    @Environment(\.dismiss) private var dismiss
    
    private var annotation: AnnotationData?
    
    init(annotation: AnnotationData?) {
        self.annotation = annotation
    }
    
    var body: some View {
        if let annotationData = annotation {
            List {
                NavigationLink("Detail") {
                    AnnotationDetail(annotation: annotationData)
                }
                NavigationLink("Groups") {
                    PeopleList(annotationId: annotationData.id)
                }
            }
            .navigationTitle(annotationData.name == "" ? "Untitled Annotation" : annotationData.name)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
