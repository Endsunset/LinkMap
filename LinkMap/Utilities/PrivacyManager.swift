//
//  PrivacyManager.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/30.
//

import Foundation

final class PrivacyManager {
    @MainActor static let shared = PrivacyManager()
    
    // Update this version number whenever you make significant policy changes
    let currentPolicyVersion = "1.1"
    private let defaults = UserDefaults.standard
    
    var isInitialVersion: Bool {
        return currentPolicyVersion == "1.0"
    }
    
    private init() {}
    
    func shouldShowPrivacyPolicy() -> Bool {
        // First launch check
        guard defaults.bool(forKey: "hasAcceptedPrivacyPolicy") else {
            return true
        }
        
        // Policy version check
        let lastAcceptedVersion = defaults.string(forKey: "lastAcceptedPolicyVersion")
        return lastAcceptedVersion != currentPolicyVersion
    }
    
    func recordAcceptance() {
        defaults.set(true, forKey: "hasAcceptedPrivacyPolicy")
        defaults.set(currentPolicyVersion, forKey: "lastAcceptedPolicyVersion")
    }
    
    func resetForTesting() {
        defaults.removeObject(forKey: "hasAcceptedPrivacyPolicy")
        defaults.removeObject(forKey: "lastAcceptedPolicyVersion")
    }
}
