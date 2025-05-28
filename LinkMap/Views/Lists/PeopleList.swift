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
    
    @State private var editMode = EditMode.inactive
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var path = NavigationPath()
    
    @State private var displayed = false
    
    init(isSheet: Bool = false, annotationId: UUID? = nil) {
        self.isSheet = isSheet
        self.annotationId = annotationId
    }
    
    var body: some View {
        //NavigationSplitView {
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
                    ToolbarItem(placement: .confirmationAction) {
                        if editMode.isEditing {
                            Button("Done") {
                                editMode = .inactive
                            }
                        } else {
                            Menu("Options") {
                                Button("Add person", systemImage: "plus", action: addPerson)
                                
                                Button {
                                    editMode = .active
                                } label: {
                                    Text("Edit")
                                    Image(systemName: "pencil")
                                }
                                
                                NavigationLink {
                                    Help()
                                } label: {
                                    Text("Help")
                                    Image(systemName: "questionmark.circle")
                                }
                            }
                        }
                    }
                }
            }
            .environment(\.editMode, $editMode)
            .sheet(item: $newPerson) { person in
                NavigationStack(path: $path) {
                    Text("Loading...")
                        .navigationDestination(for: String.self) { _ in
                            PeopleDetail(person: person, isNew: true)
                        }
                        .onAppear {
                            if displayed {
                                displayed = false
                                newPerson = nil
                            } else {
                                displayed = true
                                path.append("")
                            }
                        }
                }
                .interactiveDismissDisabled()
            }
         /*detail: {
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
