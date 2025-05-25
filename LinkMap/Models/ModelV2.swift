//
//  AnnotationV2.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/5.
//

import Foundation
@preconcurrency import SwiftData

enum LinkMapV2: VersionedSchema {
    static let versionIdentifier = Schema.Version(2, 0, 0)
    static var models: [any PersistentModel.Type] {
        [AnnotationData.self,Person.self,Item.self]
    }
    
    @Model
    final class AnnotationData {
        @Attribute(.unique) var id : UUID
        var name : String
        var longitude : Double
        var latitude : Double
        var detail : String = ""
        
        init(id: UUID = UUID(), name: String = "", longitude: Double = 0.0, latitude: Double = 0.0, detail: String = "") {
            self.id = id
            self.name = name
            self.longitude = longitude
            self.latitude = latitude
            self.detail = detail
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
        var number : Int = 1
        
        init(name: String = "", photo: String = "", requirement: String = "", statue: Bool = false, annotationId: UUID? = nil) {
            self.id = UUID()
            self.name = name
            self.photo = photo
            self.requirement = requirement
            self.statue = statue
            self.annotationId = annotationId
            self.number = 1
        }
    }
    
    @Model
    final class Item {
        @Attribute(.unique) var id : UUID
        var name : String
        var detail : String
        
        init(name: String, detail: String) {
            self.id = UUID()
            self.name = name
            self.detail = detail
        }
    }
}
