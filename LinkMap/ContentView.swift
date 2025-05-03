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
                NavigationSplitView {
                    AnnotationList()
                } detail: {
                    Text("Select an annotation")
                        .navigationTitle("Annotation")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            
            Tab("People", systemImage: "person.and.person") {
                NavigationSplitView {
                    PeopleList()
                } detail: {
                    Text("Select a person")
                        .navigationTitle("Person")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}

#Preview {
        ContentView()
            .modelContainer(SampleData.shared.modelContainer)
}
