//
//  DebugOperations.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/6/23.
//

import Foundation
import SwiftUI
import CoreData

class DebugOperations {
    
    
    static func restoreToDefault() {
        User.main.instantiateExampleItems(context: PersistenceController.context)
    }
    
    
    static func deleteAll() {
        do {
            let context = PersistenceController.context
            let entityDescriptions = context.persistentStoreCoordinator?.managedObjectModel.entities

            for entityDescription in entityDescriptions ?? [] {
                guard let entityName = entityDescription.name,
                      entityName != "User",
                      entityName != "Wage" else {
                    continue // Skip the "User" and "Wage" entities
                }

                // Fetch the instances of the current entity
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let instances = try context.fetch(fetchRequest) as? [NSManagedObject]

                // Print and delete instances
                if let instances = instances {
                    print("Entities fetched for \(entityName):", instances.count)
                    instances.forEach {
                        print("Deleting", entityName, "with ID:", $0.objectID)
                        context.delete($0)
                    }

                    // Save changes after deleting instances
                    try context.save()

                    // Fetch and print the remaining instances
                    let remainingInstances = try context.fetch(fetchRequest) as? [NSManagedObject]
                    print("Remaining \(entityName)s:")
                    remainingInstances?.forEach {
                        print("ID:", $0.objectID)
                    }
                }
            }
        } catch {
            print("ERROR BATCH DELETING: ", error)
        }
    }
    
    
    
}
