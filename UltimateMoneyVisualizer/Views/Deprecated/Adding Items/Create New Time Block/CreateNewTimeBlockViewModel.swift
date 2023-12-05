//
//  CreateNewTimeBlockViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/20/23.
//

import CoreData
import Foundation
import SwiftUI

// MARK: - ShiftProtocol

protocol ShiftProtocol {
    func getStart() -> Date
    func getEnd() -> Date

    func getTimeBlocks() -> [TimeBlock]
}

// MARK: - CreateNewTimeBlockForShiftViewModel

class CreateNewTimeBlockForShiftViewModel: CreateNewTimeBlockViewModel {
    init(shift: Shift, start: Date? = nil, end: Date? = nil) {
        super.init(shift: shift)
        if let start {
            self.start = start
        }
        if let end {
            self.end = end
        }
    }

    override func saveAction(context: NSManagedObjectContext) throws {
        try saveCheck()
        do {
            try TimeBlock(title: title,
                          start: start,
                          end: end,
                          colorHex: selectedColorHex,
                          shift: shift as? Shift,
                          user: user,
                          context: context)

        } catch {
            throw SavingError.couldNotSaveContext
        }
    }
}

// MARK: - CreateNewTimeBlockViewModel

class CreateNewTimeBlockViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var start: Date = .now.addMinutes(-30)
    @Published var end: Date = .now
    @Published var selectedColorHex: String = Color.overcastColors.first!
    @Published var showColorOptions = false
    @Published var error: SavingError? = nil
    @Published var showErrorAlert = false

    @ObservedObject var user = User.main

    let shift: ShiftProtocol

    init(shift: ShiftProtocol) {
        self.shift = shift
    }

    var pastBlocks: [CondensedTimeBlock] {
        guard let blocks = user.timeBlocks?.allObjects as? [TimeBlock] else {
            return []
        }

        var consolidated = blocks.consolidate()

        if !title.isEmpty {
            consolidated = consolidated.filter { $0.title.contains(title) }
        }

        return consolidated.sorted {
            guard let secondEnd = $1.actualBlocks(user).first?.endTime else { return true }

            guard let firstEnd = $0.actualBlocks(user).first?.endTime else { return false }

            return firstEnd > secondEnd
        }
    }

    func saveCheck() throws {
    }

    func saveAction(context: NSManagedObjectContext) throws {}

    // TODO: Write some tests cases for this
    func isOverlappingWithAnExistingBlock() -> (answer: Bool, message: String?) {
        let timeBlocks = shift.getTimeBlocks()

        // TODO: Write some tests cases for this as well. SEPARATE from the comment above. Both need test cases
        for timeBlock in timeBlocks {
            guard let existingBlockStart = timeBlock.startTime,
                  let existingBlockEnd = timeBlock.endTime
            else { continue }
            if max(start, existingBlockStart) < min(end, existingBlockEnd) {
                let message = "Overlap found between given time range (\(start.getFormattedDate(format: .minimalTime)) to \(end.getFormattedDate(format: .minimalTime))) and TimeBlock at index \(timeBlock.getTitle()) (\(existingBlockStart.getFormattedDate(format: .minimalTime)) to \(existingBlockEnd.getFormattedDate(format: .minimalTime)))."

                return (true, message)
            }
        }
        return (false, nil)
    }

    enum SavingError: Error, LocalizedError {
        case couldNotSaveContext
        case overlapping(String)
        case unknown
        case couldNotGetTodayShift

        var description: String {
            switch self {
                case .couldNotSaveContext:
                    return "Error saving. Please try again. If issue persists, try restarting the app"
                case let .overlapping(message):
                    return message
                case .unknown:
                    return "Unknown error. Please try again. If issue persists, try restarting the app"
                case .couldNotGetTodayShift:
                    return "There was an issue getting the Today Shift while saving"
            }
        }

        var errorDescription: String? {
            switch self {
                case .couldNotSaveContext:
                    return "Error saving. Please try again. If issue persists, try restarting the app"
                case let .overlapping(message):
                    return message
                case .unknown:
                    return "Unknown error. Please try again. If issue persists, try restarting the app"
                case .couldNotGetTodayShift:
                    return "There was an issue getting the Today Shift while saving"
            }
        }
    }
}
