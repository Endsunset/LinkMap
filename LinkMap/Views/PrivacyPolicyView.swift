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
    
    let privacyPolicyURL = URL(string: "https://endsunset.github.io/LinkMap/LinkMap-Privacy-Policy")!
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("LinkMap")
                .font(.largeTitle.bold())
            // Header
            Text("Terms of Use")
                .font(.title.bold())
            
            VStack(alignment: .leading, spacing: 20) {
                // Terms Text
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("By using LinkMap, you acknowledge that:")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("• The application does not collect any personal data")
                        Text("• All map functionality is provided through Apple's MapKit services")
                        Text("• You have reviewed and agree to our Privacy Policy")
                    }
                    .font(.subheadline)
                    
                    Text("LinkMap complies with all applicable privacy regulations including China's Cybersecurity Law, PIPL, and Data Security Law.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                // Privacy Policy Link
                VStack(alignment: .leading) {
                    Text("For complete details, please review our")
                    Link("Privacy Policy", destination: privacyPolicyURL)
                        .foregroundColor(.accentColor)
                }
                .font(.subheadline)
                .padding(.vertical)
            }
                
            // Acceptance Button
            Button(action: {
                PrivacyManager.shared.recordAcceptance()
                showPrivacyPolicy = false
            }) {
                Text("I understand and agree to these terms")
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
