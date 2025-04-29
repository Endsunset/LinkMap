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
    
    var body: some View {
        TabView {
            Tab("Map", systemImage: "map") {
                MapView()
            }
            
            Tab("Annotation", systemImage: "mappin.and.ellipse") {
                AnnotationList()
            }
            
            Tab("People", systemImage: "person.and.person") {
                PeopleList()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
