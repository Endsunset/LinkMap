//
//  LinkMapApp.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/11.
//

import SwiftUI
import SwiftData

@main
struct LinkMapApp: App {
    var body: some Scene {
        #if os(iOS) || os(macOS)
        DocumentGroupLaunchScene("LinkMap") {
            NewDocumentButton("v1.0")
        } background: {
            Image(.pinkJungle)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        DocumentGroup(editing: [AnnotationData.self, Person.self], contentType: .linkMap) {
            ContentView()
        }
        #else
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [AnnotationData.self, Person.self])
        #endif
    }
}
