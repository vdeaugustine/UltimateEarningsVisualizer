//
//  Persistence.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData

struct PersistenceController {
    
    
    static let context = shared.container.viewContext
   
    #if !DEBUG
    static let shared = PersistenceController()
    #else
    static var shared: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Check if there is a User entity in the persistent store
//        let request: NSFetchRequest<User> = User.fetchRequest()
//        do {
//            let count = try viewContext.count(for: request)
//            if count == 0 {
//                // If there is no User entity, create one and save it to the store
//                let user = User(context: viewContext)
//                user.username = "Testing User"
//                user.email = "TestUser@ExampleForTest.com"
//
//                let wage = Wage(context: viewContext)
//                wage.amount = 20
//                wage.user = user
//                user.wage = wage
//
//                try viewContext.save()
//            }
//        } catch {
//            // Handle the error appropriately
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }

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
