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
            NavigationStack {
                MapView()
            }
            .tabItem { Label("Map", systemImage: "map") }
            
            NavigationStack {
                            AnnotationList()
            }
            .tabItem { Label("Annotations", systemImage: "mappin.and.ellipse") }
            
            NavigationStack {
                            PeopleList()
            }
            .tabItem { Label("Groups", systemImage: "person.and.person") }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                NavigationLink("Help") {
                    NavigationControllerWrapper {
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
