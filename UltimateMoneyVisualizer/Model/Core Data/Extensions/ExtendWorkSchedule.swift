//
//  ExtendWorkSchedule.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/27/23.
//

import CoreData
import Foundation

extension WorkSchedule {
    func removeDuplicateWorkSchedules(in context: NSManagedObjectContext) {
        guard let dayOfWeek = self.dayOfWeek else {
            print("dayOfWeek is nil, cannot remove duplicates")
            return
        }

        let fetchRequest: NSFetchRequest<WorkSchedule> = WorkSchedule.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "dayOfWeek = %@", dayOfWeek)
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let results = try context.fetch(fetchRequest)

            if results.count > 1 {
                let itemsToRemove = results.dropFirst()

                for item in itemsToRemove {
                    context.delete(item)
                }
            }
        } catch {
            print("Error fetching WorkSchedules with duplicate dayOfWeek: \(error)")
        }
    }


}
