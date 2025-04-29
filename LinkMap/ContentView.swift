//
//  ContentView.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/11.
//

import SwiftUI
import SwiftData
import MapKit

var defaultMarkerTitle = "Guangzhou", defaultLatitude = 23.128994, defaultLongitude = 113.253250

struct ContentView: View {
    
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
