//
//  LinkMapApp.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/11.
//

// LinkMapApp.swift

import SwiftUI
import SwiftData

@main
struct LinkMapApp: App {
    @StateObject private var documentManager = DocumentManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(documentManager)
                .modelContainer(documentManager.modelContainer) // Now non-optional
        }
    }
}

class DocumentManager: ObservableObject {
    @Published var modelContainer: ModelContainer
    @Published var currentDocumentURL: URL?
    
    init() {
        // Initialize with temporary container first
        let tempURL = URL.temporaryDirectory.appendingPathComponent("Untitled.linkmap")
        let config = ModelConfiguration(url: tempURL)
        modelContainer = try! ModelContainer(
            for: AnnotationData.self, Person.self,
            configurations: config
        )
    }
    
    func loadDocument(url: URL) {
        let config = ModelConfiguration(url: url)
        modelContainer = try! ModelContainer(
            for: AnnotationData.self, Person.self,
            configurations: config
        )
        currentDocumentURL = url
    }
    
    func createNewDocument() {
        let tempURL = URL.temporaryDirectory.appendingPathComponent("Untitled-\(Date().timeIntervalSince1970).linkmap")
        let config = ModelConfiguration(url: tempURL)
        modelContainer = try! ModelContainer(
            for: AnnotationData.self, Person.self,
            configurations: config
        )
        currentDocumentURL = tempURL
    }
}
