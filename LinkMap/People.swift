//
//  People.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/11.
//

import Foundation
import SwiftData

@Model
class Person {
    @Attribute(.unique) var id: UUID
    var name : String
    var photo : String
    var requirement : String
    var statue : Bool
    var annotationId : UUID?
    
    init(name: String, photo: String, requirement: String, statue: Bool, annotationId: UUID? = nil) {
        self.id = UUID()
        self.name = name
        self.photo = photo
        self.requirement = requirement
        self.statue = statue
    }
    
    static let sampleData = [
        Person(name: "Alpha", photo: "/documents/photos/Alpha.jpg", requirement: "Helium", statue: false),
        Person(name: "Beta", photo: "/documents/photos/Beta.jpg", requirement: "Electron", statue: true),
        Person(name: "Cryo", photo: "/documents/photos/Cryo.jpg", requirement: "Ice", statue: false),
        Person(name: "Dendro", photo: "/documents/photos/Dendro.jpg", requirement: "Grass", statue: false),
        Person(name: "Electro", photo: "/documents/photos/Electro.jpg", requirement: "Lightning", statue: true),
    ]
}
