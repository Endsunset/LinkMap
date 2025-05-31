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
    
    @State private var path = NavigationPath()
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView {
            Tab("Map", systemImage: "map") {
                MapView()
            }
            
            Tab("Annotation", systemImage: "mappin.and.ellipse") {
                NavigationStack(path: $path) {
                    Text("Refreshing...")
                        .navigationDestination(for: String.self) { _ in
                            AnnotationList()
                                .navigationBarBackButtonHidden()
                                .onDisappear {
                                    if path.isEmpty {
                                        path.append("")
                                    }
                                }
                        }
                }
                .onAppear {
                    if path.isEmpty {
                        path.append("")
                    }
                }
            }
            
            Tab("Group", systemImage: "person.and.person") {
                NavigationStack(path: $path) {
                    Text("Refreshing...")
                        .navigationDestination(for: String.self) { _ in
                            PeopleList()
                                .navigationBarBackButtonHidden()
                                .onDisappear {
                                    if path.isEmpty {
                                        path.append("")
                                    }
                                }
                        }
                }
                .onAppear {
                    if path.isEmpty {
                        path.append("")
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
