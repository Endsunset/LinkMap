//
//  PrivacyPolicyView.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/30.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Binding var showPrivacyPolicy: Bool
    @State private var showChanges = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text("Privacy Policy \(PrivacyManager.shared.currentPolicyVersion)")
                    .font(.title.bold())
                
                if !PrivacyManager.shared.isInitialVersion &&
                    PrivacyManager.shared.shouldShowPrivacyPolicy() {
                    Button(action: { showChanges.toggle() }) {
                        Text("What's Changed?")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                }
            }
                                
            if !PrivacyManager.shared.isInitialVersion && showChanges {
                Text("""
                    Updated in v\(PrivacyManager.shared.currentPolicyVersion):
                    - Clarified data retention policies
                    - Added contact methods for data requests
                    """)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    // Introduction
                    Text("Effective Date: May 30, 2025")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    // 1. Information We Collect
                    Text("1. Information We Collect")
                        .font(.headline)
                    Text("""
                    LinkMap does not collect, store, or transmit any personal data to external servers. 
                    All data created within the app (including map annotations and user preferences) is stored exclusively on your device using Apple's SwiftData framework.
                    """)
                    
                    // 2. Location Data
                    Text("2. Location Data")
                        .font(.headline)
                    Text("""
                    If you grant permission, the app may access your location solely to:
                    - Display your position on the map
                    - Facilitate local annotation placement
                    
                    Location data is processed in real-time and never stored persistently or shared with third parties.
                    """)
                    
                    // 3. Data Security
                    Text("3. Data Security")
                        .font(.headline)
                    Text("""
                    Your data remains on your device at all times. We implement:
                    - iOS system-level security protections
                    - Sandboxing of all app data
                    """)
                    
                    // 4. Changes to This Policy
                    Text("4. Changes to This Policy")
                        .font(.headline)
                    Text("""
                    We may update this policy. Continued use after changes constitutes acceptance.
                    """)
                }
                .padding(.horizontal)
            }
            
            // Acceptance Button
            Button(action: {
                UserDefaults.standard.set(true, forKey: "hasAcceptedPrivacyPolicy")
                showPrivacyPolicy = false
            }) {
                Text("I Accept")
                    .bold()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .presentationDetents([.medium, .large]) // For better iPad/Mac sizing
    }
}

#Preview {
    @Previewable @State var showPrivacyPolicy = false
    PrivacyPolicyView(showPrivacyPolicy: $showPrivacyPolicy)
}
