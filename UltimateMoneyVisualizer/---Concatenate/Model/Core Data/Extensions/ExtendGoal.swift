//
//  ExtendExpense.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/25/23.
//

import CoreData
import Foundation
import SwiftUI
import Vin

public extension Goal {
    @discardableResult convenience init(title: String,
                                        info: String?,
                                        amount: Double,
                                        dueDate: Date?,
                                        tagStrings: [String]? = nil,
                                        image: UIImage? = nil,
                                        user: User,
                                        context: NSManagedObjectContext = PersistenceController.context) throws {
        self.init(context: context)
        self.title = title
        self.info = info
        self.amount = amount
        self.dueDate = dueDate
        self.id = UUID()
        self.user = user
        self.dateCreated = .now

        let currentQueueCount = Int16(user.getQueue().count)
        // Put the item at the back of the queue at first initialization
        self.queueSlotNumber = currentQueueCount

        if let image,
           let imageData = image.jpegData(compressionQuality: 1.0) {
            self.imageData = imageData
        }

        if let tagStrings {
            for tagStr in tagStrings {
                if let existingTag = user.getTags().first(where: { $0.getTitle() == tagStr }) {
                    existingTag.addToGoals(self)
                    addToTags(existingTag)
                    continue
                } else {
                    #if DEBUG
                        try Tag(tagStr,
                                symbol: nil,
                                color: Color.defaultColorOptions.randomElement()!,
                                goal: self,
                                user: user,
                                context: context)
                    #else
                        try Tag(tagStr,
                                symbol: nil,
                                color: user.getSettings().themeColor,
                                goal: self,
                                user: user,
                                context: context)
//                        try Tag(tagStr, symbol: nil, payoffItem: self, user: user, context: context)
                    #endif
                }
            }
        }

        try context.save()
    }
}

// MARK: - Goal + PayoffItem

extension Goal: PayoffItem {
    
    public var tempPaidOffAmount: Double? {
        get {
            amountTempPaidOff
        }
        set {
            self.amountTempPaidOff = newValue ?? 0
        }
    }
    
    public func addTag(tag: Tag) throws {
        addToTags(tag)
        try managedObjectContext?.save()
    }

    // MARK: Properties
    
    public var repeatFrequencyObject: RepeatFrequency {
        RepeatFrequency(rawValue: self.repeatFrequency ?? RepeatFrequency.never.rawValue) ?? .never
    }

    public func removeTag(tag: Tag) throws {
        removeFromTags(tag)
        try managedObjectContext?.save()
    }

    public var isPaidOff: Bool {
        amountRemainingToPayOff < 0.01
    }

    public var amountMoneyStr: String {
        return amount.money(includeCents: true)
    }

    public var amountPaidOff: Double {
        getAllocations().reduce(Double(0)) { $0 + $1.amount }
    }

    public var amountRemainingToPayOff: Double { return amount - amountPaidOff }

    public var optionalQSlotNumber: Int16? {
        get {
            if queueSlotNumber == -7_777 {
                return nil
            }
            return queueSlotNumber
        }
        set {
            queueSlotNumber = newValue ?? -7_777
        }
    }

    public var optionalTempQNum: Int16? {
        get {
            if tempQNum == -7_777 {
                return nil
            }
            return tempQNum
        }
        set {
            tempQNum = newValue ?? -7_777
        }
    }

    public var percentPaidOff: Double { amountPaidOff / amount }

    public var percentTemporarilyPaidOff: Double { temporarilyPaidOff / amount }

    public var temporarilyPaidOff: Double {
        guard let temporaryAllocations = temporaryAllocations as? Set<TemporaryAllocation>
        else {
            return 0
        }

        let totalTemporaryAllocated = temporaryAllocations.reduce(Double(0)) { $0 + $1.amount }

        return totalTemporaryAllocated + amountPaidOff
    }

    public var temporaryRemainingToPayOff: Double {
        amount - temporarilyPaidOff
    }

    public var titleStr: String { title ?? "Unknown Expense" }

    public var type: PayoffType { return .goal }

    // MARK: Methods

    // swiftformat:sort:begin
    public func getAllocations() -> [Allocation] {
        guard let allocations = Array(allocations ?? []) as? [Allocation] else { return [] }
        return allocations.sorted(by: { $0.date ?? .distantPast > $1.date ?? .distantPast })
    }

    public func getArrayOfTemporaryAllocations() -> [TemporaryAllocation] {
        guard let temporaryAllocations = temporaryAllocations?.allObjects as? [TemporaryAllocation] else {
            return []
        }
        return temporaryAllocations
    }

    public func getID() -> UUID {
        if let id { return id }
        let newID = UUID()
        id = newID

        try? managedObjectContext?.save()

        return newID
    }

    public func getMostRecentTemporaryAllocation() -> TemporaryAllocation? {
        let tempAllocsArray = getArrayOfTemporaryAllocations()

        let sorted = tempAllocsArray.sorted { ($0.lastEdited ?? .now) > ($1.lastEdited ?? .now) }

        return sorted.first
    }

    public func handleWhenPaidOff() throws {
        guard amountRemainingToPayOff <= 0 else { return }
        optionalTempQNum = nil
    }

    public func handleWhenTempPaidOff() throws {
        guard temporaryRemainingToPayOff <= 0 else { return }
        optionalTempQNum = nil
    }

    public func removeAllocation(alloc: Allocation) throws {
        removeFromAllocations(alloc)
        try managedObjectContext?.save()
    }

    // Optional Queue Slot Number
    public func setOptionalQSlotNumber(newVal: Int16?) {
        optionalQSlotNumber = newVal
    }

    // Optional Temporary Queue Number
    public func setOptionalTempQNum(newVal: Int16?) {
        optionalTempQNum = newVal
    }
}

// swiftformat:sort:end
#if DEBUG
// MARK: - Example Items for Testing
public extension Goal {
    static func makeExampleGoals(user: User, context: NSManagedObjectContext) throws {
        //        try Goal(title: "Get a basketball", info: "For playing", amount: 7, dueDate: .now.addDays(7), user: user, context: context)
        try Goal(title: "New car fund",
                 info: "Saving up for a down payment on a new car",
                 amount: 100,
                 dueDate: Date().addingTimeInterval(31_536_000),
                 tagStrings: Tag.getSomeTitles(),
                 image: UIImage(named: "disneyworld"),
                 user: user,
                 context: context)
        try Goal(title: "Vacation to Hawaii",
                 info: "Planning a trip to Hawaii with my family",
                 amount: 87,
                 dueDate: Date().addingTimeInterval(157_680_000),
                 tagStrings: Tag.getSomeTitles(),
                 user: user,
                 context: context)
        try Goal(title: "Emergency fund",
                 info: "Saving up for unexpected expenses",
                 amount: 12,
                 dueDate: nil,
                 tagStrings: Tag.getSomeTitles(),
                 user: user,
                 context: context)
        try Goal(title: "Home renovations",
                 info: "Renovating my kitchen and bathroom",
                 amount: 432,
                 dueDate: Date().addingTimeInterval(63_072_000),
                 tagStrings: Tag.getSomeTitles(),
                 user: user,
                 context: context)
        try Goal(title: "College fund for kids",
                 info: "Saving up for my kids' college education",
                 amount: 64,
                 dueDate: Date().addingTimeInterval(630_720_000),
                 tagStrings: Tag.getSomeTitles(),
                 user: user,
                 context: context)
        try Goal(title: "Retirement fund",
                 info: "Planning for retirement",
                 amount: 123,
                 dueDate: nil,
                 tagStrings: Tag.getSomeTitles(),
                 user: user,
                 context: context)
        try Goal(title: "Business venture",
                 info: "Investing in a new business opportunity",
                 amount: 154,
                 dueDate: Date().addingTimeInterval(157_680_000),
                 tagStrings: Tag.getSomeTitles(),
                 user: user,
                 context: context)
    }

    static let disneyWorld: Goal = {
        let goal = Goal(context: PersistenceController.context)
        goal.amount = 2_329
        goal.dateCreated = .now
        goal.dueDate = .now.addDays(278)
        goal.title = "Disney World"
        goal.info = "with Noah boy"
        let user = User(context: PersistenceController.context)
        user.username = "some user name"
        user.email = "vinnie@vinnie.vin"
        goal.user = user
        return goal
    }()
}
#endif 
// MARK: - Methods and properties

public extension Goal {
    // MARK: Properties

    // swiftformat:sort:begin
    var amountPaidBySaved: Double {
        let savedAllocations = getAllocations().filter { $0.savedItem != nil }
        return savedAllocations.reduce(Double.zero) { $0 + $1.amount }
    }

    var amountPaidByShifts: Double {
        let shiftAllocations = getAllocations().filter { $0.shift != nil }
        return shiftAllocations.reduce(Double.zero) { $0 + $1.amount }
    }

    func getSavedItems() -> [Saved] {
        getAllocations().compactMap { $0.savedItem }
    }

    func getShifts() -> [Shift] {
        getAllocations().compactMap { $0.shift }
    }

    // MARK: Methods

    func getTags() -> [Tag] {
        if let tagsSet = tags,
           let tagsArray = Array(tagsSet) as? [Tag] {
            return tagsArray
        }
        return []
    }

    func loadImageIfPresent() -> UIImage? {
        if let imageData {
            return UIImage(data: imageData)
        }
        return nil
    }

    func saveImage(image: UIImage) throws {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            self.imageData = imageData

            guard let context = user?.managedObjectContext else {
                throw NSError(domain: "No context found", code: 99)
            }
            try context.save()

        } else {
            throw NSError(domain: "Error converting image to data", code: 99)
        }
    }

    var timeRemaining: TimeInterval {
        guard let dueDate else { return 0 }
        return dueDate - .now
    }

    var totalTimeRemaining: TimeInterval {
        guard let dateCreated, let dueDate else { return 0 }
        return dueDate - dateCreated
    }

    // swiftformat:sort:end
}
