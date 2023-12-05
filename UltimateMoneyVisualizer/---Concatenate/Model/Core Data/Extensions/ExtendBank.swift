//
//  ExtendBank.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/5/23.
//

import Foundation
import CoreData

extension Bank {
    
    enum Source: Hashable {
        case working
        case saved
        case other(String)
        
        init(_ rawString: String) {
            switch rawString.lowercased() {
                case "working":
                    self = .working
                case "saved":
                    self = .saved
                default:
                    self = .other(rawString)
            }
        }
        
        var rawString: String {
            switch self {
                case .working:
                    return "working"
                case .saved:
                    return "saved"
                case .other(let string):
                    return string
            }
        }
    }
    
    func setSource(_ source: Source) throws {
        self.source = source.rawString
        try self.managedObjectContext?.save()
    }
    
    @discardableResult
    convenience
    init(amount: Double, dateSet: Date, source: Source, context: NSManagedObjectContext, user: User ) throws {
        self.init(context: context)
        self.amount = amount
        self.dateSetByUser = dateSet
        self.dateAdded = .now
        self.source = source.rawString
        self.user = user
        
        try context.save()
    }
    
    
    
}
