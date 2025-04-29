//
//  People.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/11.
//

import SwiftData

@Model
class Person {
    var personId : Int
    var name : String
    var photo : String
    var requirement : String
    var statue : Bool
    var annotation : Int
    
    init(personId: Int, name: String, photo: String, requirement: String, statue: Bool, annotation: Int) {
        self.personId = personId
        self.name = name
        self.photo = photo
        self.requirement = requirement
        self.statue = statue
        self.annotation = annotation
    }
    
    static let sampleData = [
        Person(personId: 1, name: "Alpha", photo: "/documents/photos/Alpha.jpg", requirement: "Helium", statue: false, annotation: 1),
        Person(personId: 2, name: "Beta", photo: "/documents/photos/Beta.jpg", requirement: "Electron", statue: true, annotation: 1),
        Person(personId: 3, name: "Cryo", photo: "/documents/photos/Cryo.jpg", requirement: "Ice", statue: false, annotation: 2),
        Person(personId: 4, name: "Dendro", photo: "/documents/photos/Dendro.jpg", requirement: "Grass", statue: false, annotation: 3),
        Person(personId: 5, name: "Electro", photo: "/documents/photos/Electro.jpg", requirement: "Lightning", statue: true, annotation: 4),
    ]
}
