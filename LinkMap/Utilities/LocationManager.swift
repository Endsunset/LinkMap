//
//  LocationManager.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/2.
//

import CoreLocation

@MainActor
final class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    
    private var requested = false
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var showPermissionAlert = false
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorization() {
        if !requested {
            switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                manager.startUpdatingLocation()
            case .denied, .restricted:
                showPermissionAlert = true
                requested = true
            @unknown default:
                break
            }
        }
    }
    
    func startUpdates() {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
}

extension LocationManager: @preconcurrency CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last?.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        startUpdates()
    }
}
