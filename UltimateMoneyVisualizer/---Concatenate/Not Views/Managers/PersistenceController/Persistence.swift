//
//  Persistence.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData

extension UserDefaults {
    static var inMemory: Bool {
        get {
            UserDefaults.standard.bool(forKey: "inMemory")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "inMemory")
        }
    }
}

// MARK: - PersistenceController

public struct PersistenceController {
    public static let context = shared.container.viewContext

    public static let testing: NSManagedObjectContext = {
        let pc = PersistenceController(inMemory: true)
        let context = pc.container.viewContext

        return context
    }()

    #if !DEBUG
        static let shared = PersistenceController()
        /// In memory means it will not persist, it will start over as new every time the app launches
        public static let inMemory: Bool = false
    #else
        /// In memory means it will not persist, it will start over as new every time the app launches
        public static var inMemory: Bool {
            #if DEBUG
                UserDefaults.inMemory
            #else
                false
            #endif
        }

        static var shared: PersistenceController = {
            let isInPreview = ProcessInfo.processInfo.environment["_XCODE_RUNNING_FOR_PREVIEWS"] == nil
            let result = PersistenceController(inMemory: false)
            return result
        }()
    #endif

    public let container: NSPersistentCloudKitContainer

    public init(inMemory: Bool = false) {
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
                // 🚨 Persistent store failed to load; log and continue without crashing
                print("🗄️ Core Data load error: \(error), userInfo: \(error.userInfo)")
                // Consider migrating, retrying, or falling back to in-memory store in a future iteration
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        #if DEBUG
        // Make sure the user is signed into iCloud, otherwise this will fail 
            if FileManager.default.ubiquityIdentityToken != nil {
                do {
                    // Use the container to initialize the development schema.
                    try container.initializeCloudKitSchema(options: [])
                } catch {
                    // Handle any errors gracefully
                    print("☁️ CloudKit schema init failed: \(String(describing: error))")
                }
            }
        #endif
    }
}
