//
//  ContentView.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/11.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject private var docManager: DocumentManager
    @State private var showDocumentPicker = false
    
    var body: some View {
        Group {
            if docManager.currentDocumentURL != nil {
                // Main interface
                TabView {
                    Tab("Map", systemImage: "map") { MapView() }
                    Tab("Annotation", systemImage: "mappin.and.ellipse") { AnnotationList() }
                    Tab("Group", systemImage: "person.and.person") { PeopleList() }
                }
            } else {
                // Welcome screen
                VStack {
                    Button("New Document") {
                        docManager.createNewDocument()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Open Document") {
                        showDocumentPicker = true
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker { url in
                docManager.loadDocument(url: url)
            }
        }
    }
}

// Add this to ContentView.swift or a new file
struct DocumentPicker: UIViewControllerRepresentable {
    var onPick: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.linkMap])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPick: (URL) -> Void
        
        init(onPick: @escaping (URL) -> Void) {
            self.onPick = onPick
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            onPick(url)
        }
    }
}
