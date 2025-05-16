//
//  LinkMapApp.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/11.
//

import SwiftUI
import SwiftData

let test = true

@main
struct LinkMapApp: App {
    
    var body: some Scene {
        #if os(iOS) || os(macOS)
        DocumentGroupLaunchScene("LinkMap") {
            NewDocumentButton("New Document")
        } background: {
            Image("UI_Background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        /*DocumentGroup(editing: .linkMap, migrationPlan: LinkMapMigrationPlan.self) {
            ContentView()
        }*/
        
        DocumentGroup(editing: [AnnotationData.self,Person.self], contentType: .linkMap) {
            ContentView()
                .navigationBarTitleDisplayMode(.inline)
        }
        #else
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [AnnotationInfo.self, Person.self])
        #endif
    }
    
}
