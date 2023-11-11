
//
//  PayoffItem.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/1/23.
//

import Foundation
import SwiftUI

// MARK: - PayoffType

public enum PayoffType: String {
    case goal, expense, tax

    init(_ expense: Expense) {
        self = .expense
    }

    init(_ goal: Goal) {
        self = .goal
    }

    init(_ payoff: PayoffItem) {
        if payoff is Goal {
            self = .goal
        } else {
            self = .expense
        }
    }

    var titleForProgressCircle: String {
        switch self {
            case .goal:
                return "GOAL"
            case .expense:
                return "EXP"
            case .tax:
                return "TAX"
        }
    }
}

// MARK: - PayoffItem

public protocol PayoffItem {
    // MARK: - Protocol Properties:

    // swiftformat:sort:begin
    var amount: Double { get }
    var amountMoneyStr: String { get }
    var amountPaidBySaved: Double { get }
    var amountPaidByShifts: Double { get }
    var amountPaidOff: Double { get }
    var amountRemainingToPayOff: Double { get }
    var dateCreated: Date? { get set }
    var dueDate: Date? { get set }
    var info: String? { get set }
    var isPaidOff: Bool { get }
    var optionalQSlotNumber: Int16? { get set }
    var optionalTempQNum: Int16? { get set }
    var percentPaidOff: Double { get }
    var percentTemporarilyPaidOff: Double { get }
    var repeatFrequencyObject: RepeatFrequency { get }
    var timeRemaining: Double { get }
    var titleStr: String { get }
    var type: PayoffType { get }
    var tempPaidOffAmount: Double? { get set }
    // swiftformat:sort:end

    // MARK: - Protocol Methods:

    // swiftformat:sort:begin
    func addTag(tag: Tag) throws
    func getAllocations() -> [Allocation]
    func getArrayOfTemporaryAllocations() -> [TemporaryAllocation]
    func getID() -> UUID
    func getMostRecentTemporaryAllocation() -> TemporaryAllocation?
    func getSavedItems() -> [Saved]
    func getShifts() -> [Shift]
    func getTags() -> [Tag]
    func handleWhenPaidOff() throws
    func handleWhenTempPaidOff() throws
    func loadImageIfPresent() -> UIImage?
    func removeAllocation(alloc: Allocation) throws
    func removeTag(tag: Tag) throws
    func setOptionalQSlotNumber(newVal: Int16?)
    func setOptionalTempQNum(newVal: Int16?)
    // swiftformat:sort:end
}

// MARK: - AnyPayoffItem

public struct AnyPayoffItem: PayoffItem, Hashable {
    // MARK: - Properties

    var payoffItem: PayoffItem

    // MARK: - Object Methods

    public func getGoal() -> Goal? {
        payoffItem as? Goal
    }

    public func getExpense() -> Expense? {
        payoffItem as? Expense
    }

    // MARK: - Protocol Properties

    // swiftformat:sort:begin

    public var amount: Double { payoffItem.amount }
    public var amountMoneyStr: String { payoffItem.amountMoneyStr }
    public var amountPaidBySaved: Double { payoffItem.amountPaidBySaved }
    public var amountPaidByShifts: Double { payoffItem.amountPaidByShifts }
    public var amountPaidOff: Double { payoffItem.amountPaidOff }
    public var amountRemainingToPayOff: Double { payoffItem.amountRemainingToPayOff }
    public var dateCreated: Date? {
        get { payoffItem.dateCreated }
        set { payoffItem.dateCreated = newValue }
    }

    public var dueDate: Date? {
        get { payoffItem.dueDate }
        set { payoffItem.dueDate = newValue }
    }

    public var info: String? {
        get {
            payoffItem.info
        }
        set {
            payoffItem.info = newValue
        }
    }

    public var isPaidOff: Bool { payoffItem.isPaidOff }
    public var optionalQSlotNumber: Int16? {
        get { payoffItem.optionalQSlotNumber }
        set { payoffItem.optionalQSlotNumber = newValue }
    }

    public var optionalTempQNum: Int16? {
        get { payoffItem.optionalTempQNum }
        set { payoffItem.optionalTempQNum = newValue }
    }

    public var percentPaidOff: Double { payoffItem.percentPaidOff }
    public var percentTemporarilyPaidOff: Double { payoffItem.percentTemporarilyPaidOff }

    public var repeatFrequencyObject: RepeatFrequency { payoffItem.repeatFrequencyObject }
    public var timeRemaining: Double { payoffItem.timeRemaining }
    public var titleStr: String { payoffItem.titleStr }
    public var type: PayoffType { payoffItem.type }
    public var tempPaidOffAmount: Double? {
        get {
            payoffItem.tempPaidOffAmount
        }
        set {
            payoffItem.tempPaidOffAmount = newValue
        }
    }

    // swiftformat:sort:end

    // MARK: - Protocol Methods

    // swiftformat:sort:begin

    public func addTag(tag: Tag) throws { try payoffItem.addTag(tag: tag) }

    public func getAllocations() -> [Allocation] { payoffItem.getAllocations() }
    public func getArrayOfTemporaryAllocations() -> [TemporaryAllocation] { payoffItem.getArrayOfTemporaryAllocations() }
    public func getID() -> UUID { payoffItem.getID() }
    public func getMostRecentTemporaryAllocation() -> TemporaryAllocation? { payoffItem.getMostRecentTemporaryAllocation() }
    public func getSavedItems() -> [Saved] { payoffItem.getSavedItems() }
    public func getShifts() -> [Shift] { payoffItem.getShifts() }
    public func getTags() -> [Tag] { payoffItem.getTags() }
    public func handleWhenPaidOff() throws { try payoffItem.handleWhenPaidOff() }
    public func handleWhenTempPaidOff() throws { try payoffItem.handleWhenTempPaidOff() }
    public func loadImageIfPresent() -> UIImage? { payoffItem.loadImageIfPresent() }
    public func removeAllocation(alloc: Allocation) throws { try payoffItem.removeAllocation(alloc: alloc) }
    public func removeTag(tag: Tag) throws { try payoffItem.removeTag(tag: tag) }
    public func setOptionalQSlotNumber(newVal: Int16?) { payoffItem.setOptionalQSlotNumber(newVal: newVal) }
    public func setOptionalTempQNum(newVal: Int16?) { payoffItem.setOptionalTempQNum(newVal: newVal) }

    // swiftformat:sort:end

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(payoffItem.getID())
    }

    // MARK: - Initializer

    public init(_ item: PayoffItem) {
        self.payoffItem = item
    }

    // MARK: - Equatable

    public static func == (lhs: AnyPayoffItem, rhs: AnyPayoffItem) -> Bool {
        return lhs.payoffItem.getID() == rhs.payoffItem.getID()
    }
}

// public struct AnyPayoffItem: PayoffItem, Identifiable {
//    public func getID() -> UUID {
//        <#code#>
//    }
//
//    public var dateCreated: Date?
//
//    public var id: UUID?
//
//    private let _getQueueSlotNumber: () -> Int16
//    private let _setQueueSlotNumber: (Int16) -> Void
//
//    public init<T: PayoffItem>(_ wrapped: T) {
//        _getQueueSlotNumber = { wrapped.queueSlotNumber }
//        _setQueueSlotNumber = { newValue in
//            var mutableWrapped = wrapped
//            mutableWrapped.queueSlotNumber = newValue
//        }
//
//        dateCreated = wrapped.dateCreated
//        id = wrapped.id
//    }
//
//    public var queueSlotNumber: Int16 {
//        get {
//            return _getQueueSlotNumber()
//        }
//        set {
//            _setQueueSlotNumber(newValue)
//        }
//    }
// }
