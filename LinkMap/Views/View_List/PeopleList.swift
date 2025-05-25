//
//  PeopleList.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/13.
//

import SwiftUI
import SwiftData

struct PeopleList: View {
    let isSheet: Bool
    let annotationId: UUID?
    
    @Query(sort: \Person.id) private var people: [Person]
    @Query(sort: \AnnotationData.id) private var annotations: [AnnotationData]
    @Environment(\.modelContext) private var context
    @State private var newPerson: Person?
    
    @Environment(\.dismiss) private var dismiss
    
    init(isSheet: Bool = false, annotationId: UUID? = nil) {
        self.isSheet = isSheet
        self.annotationId = annotationId
    }
    
    var body: some View {
        //NavigationSplitView {
        NavigationStack {
            List {
                ForEach(people) { person in
                    if annotationId == person.annotationId || annotationId == nil {
                        NavigationLink(person.name == "" ? "Untitled Group" : person.name) {
                            PeopleDetail(person: person)
                        }
                    }
                }
                .onDelete(perform: deletePeople(indexes:))
            }
            .navigationTitle("Groups")
            .toolbar {
                if isSheet {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                } else {
                    ToolbarItem {
                        Button("Add person", systemImage: "plus", action: addPerson)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        EditButton()
                    }
                }
                
            }
            .sheet(item: $newPerson) { person in
                NavigationStack {
                    PeopleDetail(person: person, isNew: true)
                        .toolbarBackgroundVisibility(.hidden)
                        .navigationBarBackButtonHidden()
                        .toolbarRole(.editor)
                }
                .interactiveDismissDisabled()
            }
        } /*detail: {
            Text("Select a person")
                .navigationTitle("Person")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarTitleDisplayMode(.inline)*/
        .toolbarRole(.editor)
    }
    
    private func addPerson() {
        let newPerson = Person(name: "", photo: "", requirement: "", statue: false, annotationId: annotationId)
        context.insert(newPerson)
        self.newPerson = newPerson
    }
    
    private func deletePeople(indexes: IndexSet) {
        for index in indexes {
            context.delete(people[index])
        }
    }
}

#Preview {
    PeopleList()
        .modelContainer(for: [AnnotationData.self, Person.self])
}
