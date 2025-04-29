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
        WindowGroup {
            ContentView()
                .modelContainer(for: [AnnotationData.self, Person.self])
        }
    }
}
