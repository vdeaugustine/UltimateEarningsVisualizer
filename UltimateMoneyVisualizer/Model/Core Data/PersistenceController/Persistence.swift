//
//  Persistence.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData

public struct PersistenceController {
    public static let context = shared.container.viewContext

    public static let testing: NSManagedObjectContext = {
        let pc = PersistenceController(inMemory: true)
        let context = pc.container.viewContext

        return context
    }()

    #if !DEBUG
        static let shared = PersistenceController()
    #else
        static var shared: PersistenceController = {
            let isInPreview = ProcessInfo.processInfo.environment["_XCODE_RUNNING_FOR_PREVIEWS"] == nil
            print("Is in preview, therefore memory:", isInPreview)
            let result = PersistenceController(inMemory: isInPreview)
            let viewContext = result.container.viewContext

            return result
        }()
    #endif

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        self.container = NSPersistentCloudKitContainer(name: "UltimateMoneyVisualizer")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
