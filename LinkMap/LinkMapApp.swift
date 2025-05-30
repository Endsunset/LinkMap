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
    @State private var showPrivacyPolicy = false
    
    var body: some Scene {
        // Main Document Group
        DocumentGroup(editing: [AnnotationData.self, Person.self], contentType: .linkMap) {
            ContentView()
                .onAppear {
                    // Only show if not previously accepted
                    if !UserDefaults.standard.bool(forKey: "hasAcceptedPrivacyPolicy") {
                        showPrivacyPolicy = true
                    }
                }
                .sheet(isPresented: $showPrivacyPolicy) {
                    PrivacyPolicyView(showPrivacyPolicy: $showPrivacyPolicy)
                        .interactiveDismissDisabled() // Force acceptance
                        #if os(macOS)
                        .frame(minWidth: 500, minHeight: 600)
                        #endif
                }
        }
    }
}
