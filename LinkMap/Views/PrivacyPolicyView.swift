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
            // Acceptance Button
            Button(action: {
                PrivacyManager.shared.recordAcceptance()
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
        .background(Color(.systemBackground)) // For better iPad/Mac sizing
    }
}

#Preview {
    @Previewable @State var showPrivacyPolicy = false
    PrivacyPolicyView(showPrivacyPolicy: $showPrivacyPolicy)
}
