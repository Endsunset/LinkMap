//
//  Schema.swift
//  LinkMap
//
//  Created by Yuan Ping Ke on 2025/5/5.
//

import SwiftUI
import SwiftData

typealias AnnotationData = LinkMapV2.AnnotationData
typealias Person = LinkMapV2.Person

enum LinkMapMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [LinkMapV1.self, LinkMapV2.self]
    }

    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
    
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: LinkMapV1.self,
        toVersion: LinkMapV2.self
    )
    
    static let migrateV1toV2custom = MigrationStage.custom(
        fromVersion: LinkMapV1.self,
        toVersion: LinkMapV2.self,
        willMigrate: { context in
            let oldAnnotations = try context.fetch(FetchDescriptor<LinkMapV1.AnnotationData>())

                        // Migrate each V1 AnnotationData to V2
            for oldAnnotation in oldAnnotations {
                let newAnnotation = LinkMapV2.AnnotationData(
                    id: oldAnnotation.id,
                    name: oldAnnotation.name,
                    longitude: oldAnnotation.longitude,
                    latitude: oldAnnotation.latitude,
                    detail: ""  // Explicitly set to nil (or provide a default)
                )
                context.insert(newAnnotation)
            }
            try context.save()
        },
        didMigrate: { context in
            print("Migration to V2 completed!")
        }
    )
}
