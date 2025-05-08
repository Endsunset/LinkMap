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
    
    @State private var showPicker = false
    let numbers = Array(1...100)
    
    init(person: Person, isNew: Bool = false) {
        self.person = person
        self.isNew = isNew
    }
    
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $person.name)
                    .autocorrectionDisabled()
                
                Button {
                    showPicker.toggle()
                } label: {
                    HStack {
                        Text("Number of People")
                        Spacer()
                        Text("\(person.number)")
                            .foregroundColor(.secondary)
                    }
                }
                .sheet(isPresented: $showPicker) {
                    NavigationStack {
                        Picker("Number of People", selection: $person.number) {
                            ForEach(numbers, id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        .pickerStyle(.wheel)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    showPicker = false
                                }
                            }
                        }
                    }
                    .presentationDetents([.medium]) // For a half-modal appearance (iOS 16+)
                }
                
                Picker("Annotation", selection: $person.annotationId) {
                    ForEach(annotations, id: \.id) { annotation in
                        Text(annotation.name).tag(annotation.id)
                    }
                }
                .pickerStyle(.menu)
                TextField("Detail", text: $person.requirement, axis: .vertical)
                    .lineLimit(10...10) // Forces single line
                    .fixedSize(horizontal: false, vertical: true) // Prevents vertical truncation
                    .scrollDismissesKeyboard(.interactively) // Better UX when scrolling
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
    PeopleDetail(person: Person(), isNew: false)
        .modelContainer(for: [AnnotationData.self, Person.self])
}
