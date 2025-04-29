//
//  PeopleList.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/13.
//

import SwiftUI
import SwiftData

struct PeopleList: View {
    @Query(sort: \Person.personId) private var people: [Person]
    @Environment(\.modelContext) private var context
    @State private var newPerson: Person?
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(people) { person in
                    NavigationLink(person.name) {
                        PeopleDetail(person: person)
                        
                    }
                    /*
                    HStack {
                        if person.statue {
                            Image(systemName: "checkmark")
                        } else {
                            Image(systemName: "xmark")
                        }
                        Text(person.name)
                            .bold(!person.statue)
                    }
                     */
                }
                .onDelete(perform: deletePeople(indexes:))
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem {
                    Button("Add person", systemImage: "plus", action: addPerson)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                
            }
            .sheet(item: $newPerson) { person in
                NavigationStack {
                    PeopleDetail(person: person, isNew: true)
                }
                .interactiveDismissDisabled()
            }
            /*
            .safeAreaInset(edge: .bottom) {
                VStack(alignment: .center, spacing: 20) {
                    Text("New Record")
                        .font(.headline)
                    TextField("Name", text: $newName)
                        .textFieldStyle(.roundedBorder)
                    Button("Save") {
                        let newPerson = Person(id: newId, name: newName, photo: newPhoto + newName + ".jpg", requirement: newRequirement, statue: newStatue,annotation: newAnnotation)
                        context.insert(newPerson)
                        
                        newId += 1
                        newName = ""
                    }
                    .bold()
                }
                .padding()
                .background(.bar)
            }
             */
        } detail: {
            Text("Select a person")
                .navigationTitle("Person")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func addPerson() {
        let newPerson = Person(personId: 1, name: "New name", photo: "/document", requirement: "New requirement", statue: false, annotation: 1)
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
        .modelContainer(SampleData.shared.modelContainer)
}
