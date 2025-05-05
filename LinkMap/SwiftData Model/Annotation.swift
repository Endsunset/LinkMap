//
//  Annotation.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/11.
//

import Foundation
import SwiftData

@Model
class AnnotationData {
    @Attribute(.unique) var id: UUID
    var name : String
    var longitude : Double
    var latitude : Double
    
    init(name: String, longitude: Double, latitude: Double) {
        self.id = UUID()
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
    
    static let sampleData = [
        AnnotationData(name: "Guangzhou", longitude: 113.253250, latitude: 23.128994),
        AnnotationData(name: "Shanghai", longitude: 121.472644, latitude: 31.231706),
        AnnotationData(name: "Hong kong", longitude: 114.177314, latitude: 22.266416),
        AnnotationData(name: "Beijin", longitude: 116.405285, latitude: 39.904989),
        AnnotationData(name: "Taipei", longitude: 121.565170, latitude: 25.037798),
        ]
}
