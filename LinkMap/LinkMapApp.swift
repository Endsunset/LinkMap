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
    private var privacyManager = PrivacyManager.shared
    
    var body: some Scene {
        DocumentGroup(editing: [AnnotationData.self, Person.self], contentType: .linkMap) {
            ContentView()
                .onAppear {
                    if privacyManager.shouldShowPrivacyPolicy() {
                        showPrivacyPolicy = true
                    } else {
                        locationManager.requestAuthorization(showCustomAlertIfDenied: false)
                    }
                }
                .sheet(isPresented: $showPrivacyPolicy) {
                    PrivacyPolicyView(showPrivacyPolicy: $showPrivacyPolicy)
                        .onDisappear {
                            locationManager.requestAuthorization(showCustomAlertIfDenied: false)
                        }
                }
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        }
    }
}
