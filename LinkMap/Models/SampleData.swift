//
//  SampleData.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/4/13.
//

/*import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    var annotation: AnnotationInfo {
        AnnotationInfo.sampleData.first!
    }
    
    var person: Person {
        Person.sampleData.first!
    }
    
    private init() {
        let schema = Schema([
            Person.self,
            AnnotationInfo.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            insertSampleData()
            
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func insertSampleData() {
        for annotation in AnnotationInfo.sampleData {
            context.insert(annotation)
        }
        
        for person in Person.sampleData {
            context.insert(person)
        }
    }
}
*/
