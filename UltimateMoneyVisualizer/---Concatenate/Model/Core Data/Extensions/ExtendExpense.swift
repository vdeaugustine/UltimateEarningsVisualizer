
import CoreData
import Foundation
import SwiftUI
import Vin

// MARK: - Initializer

public extension Expense {
    @discardableResult convenience init(title: String,
                                        info: String?,
                                        amount: Double,
                                        dueDate: Date?,
                                        dateCreated: Date? = nil,
                                        isRecurring: Bool = false,
                                        recurringDate: Date? = nil,
                                        tagStrings: [String]? = nil,
                                        repeatFrequency: RepeatFrequency? = nil,
                                        user: User,
                                        context: NSManagedObjectContext = PersistenceController.context) throws {
        self.init(context: context)
        self.title = title
        self.info = info
        self.amount = amount
        self.dueDate = dueDate
        self.isRecurring = isRecurring
        self.recurringDate = recurringDate
        self.user = user
        self.dateCreated = dateCreated ?? .now

        let currentQueueCount = Int16(user.getQueue().count)
        // Put the item at the back of the queue at first initialization
        self.queueSlotNumber = currentQueueCount

        if let tagStrings {
            for tagStr in tagStrings {
                if let existingTag = user.getTags().first(where: { $0.getTitle() == tagStr }) {
                    existingTag.addToExpenses(self)
                    addToTags(existingTag)
                    continue
                } else {
                    try Tag(tagStr, symbol: nil, expense: self, user: user, context: context)
                }
            }
        }

        self.id = UUID()
    }
}

// MARK: - Recurring Expenses

extension Expense {
    var recurringDayNumber: Int? {
        guard let recurringDate
        else { return nil }
        let dayNumber = Calendar.current.component(.day, from: recurringDate)
        return min(dayNumber, 30)
    }
}

// MARK: - Expense + PayoffItem

extension Expense: PayoffItem {
    public func addTag(tag: Tag) throws {
        addToTags(tag)
        try managedObjectContext?.save()
    }

    public func removeTag(tag: Tag) throws {
        removeFromTags(tag)
        try managedObjectContext?.save()
    }

    // swiftformat:sort:begin

    public var amountMoneyStr: String {
        return amount.money(includeCents: true)
    }

    public var amountPaidBySaved: Double {
        let savedAllocations = getAllocations().filter { $0.savedItem != nil }
        return savedAllocations.reduce(Double.zero) { $0 + $1.amount }
    }

    public var amountPaidByShifts: Double {
        let shiftAllocations = getAllocations().filter { $0.shift != nil }
        return shiftAllocations.reduce(Double.zero) { $0 + $1.amount }
    }

    public var amountPaidOff: Double {
        getAllocations().reduce(Double(0)) { $0 + $1.amount }
    }

    public var amountRemainingToPayOff: Double { return amount - amountPaidOff }

    public func getAllocations() -> [Allocation] {
        guard let allocations = Array(allocations ?? []) as? [Allocation] else { return [] }
        return allocations
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

    public func getSavedItems() -> [Saved] {
        getAllocations().compactMap { $0.savedItem }
    }

    public func getShifts() -> [Shift] {
        getAllocations().compactMap { $0.shift }
    }

    public func getTags() -> [Tag] {
        if let tagsArray = tags?.allObjects as? [Tag] {
            return tagsArray
        }
        return []
    }

    public func handleWhenPaidOff() throws {
        guard amountRemainingToPayOff <= 0 else { return }
        optionalTempQNum = nil
    }

    public func handleWhenTempPaidOff() throws {
        guard temporaryRemainingToPayOff <= 0 else { return }
        optionalTempQNum = nil
    }

    public var isPaidOff: Bool {
        amountRemainingToPayOff < 0.01
    }

    public var isPassedDue: Bool { timeRemaining <= 0 }
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

    public var type: PayoffType { return .expense }

    // swiftformat:sort:end
}

// MARK: - Expense Properties

public extension Expense {
    var totalTime: TimeInterval {
        guard let dateCreated, let dueDate else { return 0 }
        return dueDate - dateCreated
    }

    var timeRemaining: TimeInterval {
        guard let dueDate else { return 0 }
        return dueDate - .now
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
}

// MARK: - Examples for Testing

public extension Expense {
    static func createExampleExpenses(user: User, context: NSManagedObjectContext) throws {
        func randomDateWithin(days: Int) -> Date {
            let calendar = Calendar.current
            let today = Date()
            let earliestDate = calendar.date(byAdding: .day, value: days, to: today)

            guard let earliest = earliestDate, earliest <= today else {
                return .now
            }

            let latest = calendar.startOfDay(for: today)
            let randomTimeInterval = TimeInterval.random(in: earliest.timeIntervalSince1970 ..< latest.timeIntervalSince1970)
            let randomDate = Date(timeIntervalSince1970: randomTimeInterval)

            return randomDate
        }

        let goBackDays = 90
        let expense1 = Expense(context: context)
        expense1.title = "Groceries"
        expense1.amount = 50.00
        expense1.dateCreated = randomDateWithin(days: -goBackDays)
        expense1.dueDate = randomDateWithin(days: goBackDays)
        expense1.user = user
        expense1.info = "This expense is for groceries"

        let expense2 = Expense(context: context)
        expense2.title = "Gas"
        expense2.amount = 30.00
        expense2.dateCreated = Date()
        expense2.dateCreated = randomDateWithin(days: -goBackDays)
        expense2.dueDate = randomDateWithin(days: goBackDays)
        expense2.user = user
        expense2.info = "This expense is for gas"

        let expense3 = Expense(context: context)
        expense3.title = "Electricity"
        expense3.amount = 100.00
        expense3.dateCreated = Date()
        expense3.dateCreated = randomDateWithin(days: -goBackDays)
        expense3.dueDate = randomDateWithin(days: goBackDays)
        expense3.user = user
        expense3.info = "This expense is for electricity"

        let expense4 = Expense(context: context)
        expense4.title = "Internet"
        expense4.amount = 60.00
        expense4.dateCreated = Date()
        expense4.dateCreated = randomDateWithin(days: -goBackDays)
        expense4.dueDate = randomDateWithin(days: goBackDays)
        expense4.user = user
        expense4.info = "This expense is for internet"

        let expense5 = Expense(context: context)
        expense5.title = "Entertainment"
        expense5.amount = 25.00
        expense5.dateCreated = randomDateWithin(days: -goBackDays)
        expense5.dueDate = randomDateWithin(days: goBackDays)
        expense5.user = user
        expense5.info = "This expense is for entertainment"

        try context.save()
    }

    static func makeExampleExpenses(user: User, context: NSManagedObjectContext) throws {
        try Expense(title: "Groceries",
                    info: "Weekly grocery shopping",
                    amount: 150.0,
                    dueDate: Date().addDays(Double.random(in: -5 ..< 5)),
                    tagStrings: Tag.getSomeTitles(),
                    user: user,
                    context: context)
        try Expense(title: "Netflix",
                    info: "Monthly subscription",
                    amount: 14.99,
                    dueDate: Date().addDays(Double.random(in: -5 ..< 5)),
                    tagStrings: Tag.getSomeTitles(),
                    user: user,
                    context: context)
        try Expense(title: "Gym Membership",
                    info: "Monthly gym membership",
                    amount: 50.0,
                    dueDate: Date().addDays(Double.random(in: -5 ..< 5)),
                    tagStrings: Tag.getSomeTitles(),
                    user: user,
                    context: context)
        try Expense(title: "Car Insurance",
                    info: "Six-month premium",
                    amount: 600.0,
                    dueDate: Date().addDays(Double.random(in: -5 ..< 5)),
                    tagStrings: Tag.getSomeTitles(),
                    user: user,
                    context: context)
        try Expense(title: "Phone Bill",
                    info: "Monthly phone bill",
                    amount: 80.0,
                    dueDate: Date().addDays(Double.random(in: -5 ..< 5)),
                    tagStrings: Tag.getSomeTitles(),
                    user: user,
                    context: context)
        try Expense(title: "Birthday Gift",
                    info: "Gift for friend's birthday",
                    amount: 50.0,
                    dueDate: Date().addDays(Double.random(in: -5 ..< 5)),
                    tagStrings: Tag.getSomeTitles(),
                    user: user,
                    context: context)
        try Expense(title: "Airfare",
                    info: "Roundtrip flight for vacation",
                    amount: 500.0,
                    dueDate: Date().addDays(Double.random(in: -5 ..< 5)),
                    tagStrings: Tag.getSomeTitles(),
                    user: user,
                    context: context)
        try Expense(title: "Concert Tickets",
                    info: "Tickets for upcoming concert",
                    amount: 200.0,
                    dueDate: Date().addDays(Double.random(in: -5 ..< 5)),
                    tagStrings: Tag.getSomeTitles(),
                    user: user,
                    context: context)
        try Expense(title: "Dinner Date",
                    info: "Dinner at fancy restaurant",
                    amount: 100.0,
                    dueDate: Date().addDays(Double.random(in: -5 ..< 5)),
                    tagStrings: Tag.getSomeTitles(),
                    user: user,
                    context: context)
        try Expense(title: "Home Decor",
                    info: "New furniture for living room",
                    amount: 1_000.0,
                    dueDate: Date().addDays(Double.random(in: -5 ..< 5)),
                    tagStrings: Tag.getSomeTitles(),
                    user: user,
                    context: context)
        try context.save()
    }

    static func makeExpensesThatWontBeAllocated(user: User, context: NSManagedObjectContext) throws {
        try Expense(title: "Food meal plan",
                    info: "Monthly subscription",
                    amount: 150,
                    dueDate: nil,
                    dateCreated: .now,
                    isRecurring: true,
                    recurringDate: nil,
                    tagStrings: ["Food", "Health", "Necessities"],
                    user: user,
                    context: context)
    }
}



public enum RepeatFrequency: String, Identifiable, CaseIterable, Hashable {
    case never = "Never"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"

    public var id: String { self.rawValue }
}



