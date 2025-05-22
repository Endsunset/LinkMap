//
//  AnnotationV1.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/5.
//

import Foundation
import SwiftData

enum LinkMapV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] {
        [AnnotationData.self, Person.self]
    }
    
    @Model
    final class AnnotationData {
        @Attribute(.unique) var id : UUID
        var name : String
        var longitude : Double
        var latitude : Double
        
        init(id: UUID = UUID(), name: String = "", longitude: Double = 0.0, latitude: Double = 0.0) {
            self.id = id
            self.name = name
            self.longitude = longitude
            self.latitude = latitude
        }
    }
    
    @Model
    final class Person {
        @Attribute(.unique) var id : UUID
        var name : String
        var photo : String
        var requirement : String
        var statue : Bool
        var annotationId : UUID?
        
        init(name: String = "", photo: String = "", requirement: String = "", statue: Bool = false, annotationId: UUID? = nil) {
            self.id = UUID()
            self.name = name
            self.photo = photo
            self.requirement = requirement
            self.statue = statue
        }
    }
}
