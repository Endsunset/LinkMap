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
    @StateObject private var locationManager = LocationManager.shared
    
    var body: some Scene {
        DocumentGroup(editing: [AnnotationData.self, Person.self], contentType: .linkMap) {
            ContentView()
                .onAppear {
                    locationManager.requestAuthorization(showCustomAlertIfDenied: false)
                }
                .navigationBarHidden(false)
        }
    }
}
