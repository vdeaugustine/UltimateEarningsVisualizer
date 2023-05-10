//
//  PayoffItem.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/1/23.
//

import Foundation

public enum PayoffType: String {
    case goal, expense
    
    init(_ expense: Expense) {
        self = .expense
    }
    
    init(_ goal: Goal) {
        self = .goal
    }
    
    init(_ payoff: PayoffItem) {
        if payoff is Goal {
            self = .goal
        }
        else {
            self = .expense
        }
    }
}

public protocol PayoffItem {
    

    // MARK: - Protocol Properties:
    
    var amount: Double { get }
    var amountMoneyStr: String { get }
    var amountPaidOff: Double { get }
    var amountRemainingToPayOff: Double { get }
    var dateCreated: Date? { get set }
    var optionalQSlotNumber: Int16? { get set }
    var optionalTempQNum: Int16? { get set }
    var percentPaidOff: Double { get }
    var percentTemporarilyPaidOff: Double { get }
    var titleStr: String { get }
    var type: PayoffType { get }
    
    
    // MARK: - Protocol Methods:
    
    func getArrayOfTemporaryAllocations() -> [TemporaryAllocation]
    func getAllocations() -> [Allocation]
    func getID() -> UUID
    func getMostRecentTemporaryAllocation() -> TemporaryAllocation?
    func handleWhenPaidOff() throws
    func handleWhenTempPaidOff() throws
    func setOptionalQSlotNumber(newVal: Int16?)
    func setOptionalTempQNum(newVal: Int16?)
    
}


//public struct AnyPayoffItem: PayoffItem, Identifiable {
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
//}



