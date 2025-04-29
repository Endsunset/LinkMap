//
//  Annotation.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/11.
//

import SwiftData

@Model
class AnnotationData {
    var annotationId : Int
    var name : String
    var longitude : Double
    var latitude : Double
    
    init(annotationId: Int, name: String, longitude: Double, latitude: Double) {
        self.annotationId = annotationId
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
    
    static let sampleData = [
        AnnotationData(annotationId: 1, name: "Guangzhou", longitude: 113.253250, latitude: 23.128994),
        AnnotationData(annotationId: 2, name: "Shanghai", longitude: 121.472644, latitude: 31.231706),
        AnnotationData(annotationId: 3, name: "Hong kong", longitude: 114.177314, latitude: 22.266416),
        AnnotationData(annotationId: 4, name: "Beijin", longitude: 116.405285, latitude: 39.904989),
        AnnotationData(annotationId: 5, name: "Taipei", longitude: 121.565170, latitude: 25.037798),
        ]
}
