//
//  LocationManager.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/2.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @MainActor static let shared = LocationManager()
    private let manager = CLLocationManager()
    @Published var showPermissionAlert = false
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorization(showCustomAlertIfDenied: Bool = true) {
        let status = manager.authorizationStatus // Modern API
        
        switch status {
        case .notDetermined:
            // System will show its native prompt
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            if showCustomAlertIfDenied {
                showPermissionAlert = true
            }
        case .authorizedAlways, .authorizedWhenInUse:
            // Already authorized - start updates if needed
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    // Handle authorization changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .denied || status == .restricted {
            showPermissionAlert = true
        }
    }
}
