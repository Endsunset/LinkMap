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
    @Environment(\.modelContext) private var context
    @State private var newPerson: Person?
    
    @Environment(\.dismiss) private var dismiss
    
    init(isSheet: Bool = false, annotationId: UUID? = nil) {
        self.isSheet = isSheet
        self.annotationId = annotationId
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(people) { person in
                    if annotationId == person.annotationId || annotationId == nil {
                        NavigationLink(person.name) {
                            PeopleDetail(person: person)
                            
                        }
                    }
                }
                .onDelete(perform: deletePeople(indexes:))
            }
            .navigationTitle("People")
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
                }
                .interactiveDismissDisabled()
            }
        } detail: {
            Text("Select a person")
                .navigationTitle("Person")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addPerson() {
        let newPerson = Person(name: "New name", photo: "/document", requirement: "New requirement", statue: false)
        context.insert(newPerson)
        self.newPerson = newPerson
    }
    
    private func deletePeople(indexes: IndexSet) {
        for index in indexes {
            context.delete(people[index])
        }
    }
    
    func getIndex(of person: Person) -> Int? {
        return people.firstIndex(where: { $0.persistentModelID == person.persistentModelID })
    }
}


#Preview {
    PeopleList()
        .modelContainer(SampleData.shared.modelContainer)
}

#Preview {
    PeopleList(isSheet: true)
        .modelContainer(SampleData.shared.modelContainer)
}
