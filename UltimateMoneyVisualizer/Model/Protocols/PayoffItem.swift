//
//  PayoffItem.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/1/23.
//

import Foundation

public protocol PayoffItem {
    
    var optionalQSlotNumber: Int16? { get set }
    var dateCreated: Date? { get set }
    func getID() -> UUID
    var percentPaidOff: Double { get }
    var titleStr: String { get }
    var optionalTempQNum: Int16? { get set }
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



