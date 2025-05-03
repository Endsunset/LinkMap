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
    @Query(sort: \AnnotationData.id) private var annotations: [AnnotationData]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    init(person: Person, isNew: Bool = false) {
        self.person = person
        self.isNew = isNew
    }
    
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $person.name)
                    .autocorrectionDisabled()
                Picker("Annotation", selection: $person.annotationId) {
                    ForEach(annotations, id: \.id) { annotation in
                        Text(annotation.name).tag(annotation.id)
                    }
                }
                .pickerStyle(.menu)
                TextEditor(text: $person.requirement)
                    .frame(minHeight: 40) // Minimum height
            }
        }
        .navigationTitle(isNew ? "New Person" : "Person")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: person) { _, _ in  // Saves when ANY property changes
            save()
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
                        context.delete(person)
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
        PeopleDetail(person: SampleData.shared.person)
    }
}

#Preview("New Person") {
    NavigationStack {
        PeopleDetail(person: SampleData.shared.person, isNew: true)
    }
}
