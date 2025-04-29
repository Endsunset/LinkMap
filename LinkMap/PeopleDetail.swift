//
//  PeopleDetail.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/14.
//

import SwiftUI
import SwiftData
import MapKit

struct PeopleDetail: View {
    @Bindable var person: Person
    let isNew: Bool
    @Query(sort: \AnnotationData.annotationId) private var annotations: [AnnotationData]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    init(person: Person, isNew: Bool = false) {
        self.person = person
        self.isNew = isNew
    }
    
    var body: some View {
        VStack {
            /*
            Map {
                Marker(annotations[person.annotation], coordinate: CLLocationCoordinate2D(latitude: annotations[person.annotation].latitude, longitude: annotations[person.annotation].longitude))
            }
             */
            Form {
                TextField("Name", text: $person.name)
                    .autocorrectionDisabled()
                TextField("requirement", text: $person.requirement)
                TextField("AnnotationId", value: $person.annotation, format: .number)
            }
            .navigationTitle(isNew ? "New Person" : "Person")
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
                            context.delete(person)
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
        PeopleDetail(person: SampleData.shared.person)
    }
}

#Preview("New Person") {
    NavigationStack {
        PeopleDetail(person: SampleData.shared.person, isNew: true)
    }
}
