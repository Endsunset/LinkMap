//
//  ContentView.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/11.
//

import SwiftUI
import SwiftData
import MapKit

struct ContentView: View {
    @Query private var people: [Person]
    @Query private var annotations: [AnnotationData]
    @Environment(\.modelContext) private var context
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        TabView {
            Tab("Map", systemImage: "map") {
                MapView()
            }
            
            Tab("Annotation", systemImage: "mappin.and.ellipse") {
                VStack {
                    AnnotationList()
                }
            }
            
            Tab("Group", systemImage: "person.and.person") {
                VStack {
                    PeopleList()
                }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink("Help") {
                    NavigationStack {
                        Help()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [AnnotationData.self, Person.self])
}
