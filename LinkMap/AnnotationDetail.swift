//
//  AnnotationDetail.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/14.
//

import SwiftUI
import MapKit

struct AnnotationDetail: View {
    @Bindable var annotation: AnnotationData
    let isNew: Bool
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    init(annotation: AnnotationData, isNew: Bool = false) {
        self.annotation = annotation
        self.isNew = isNew
    }
    
    var body: some View {
        VStack {
            Map {
                Marker(annotation.name, coordinate: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude))
            }
            Form {
                TextField("Name", text: $annotation.name)
                    .autocorrectionDisabled()
                TextField("Latitude", value: $annotation.latitude, format: .number)
                TextField("Longitude", value: $annotation.longitude, format: .number)
            }
            .navigationTitle(isNew ? "New Annotation" : "Annotation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isNew {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            context.delete(annotation)
                            dismiss()
                        }
                    }
                }
            }
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
