//
//  CreateNewTimeBlockViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/20/23.
//

import CoreData
import Foundation
import SwiftUI

class CreateNewTimeBlockViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var start: Date = .now
    @Published var end: Date = .now
    @Published var selectedColorHex: String = Color.overcastColors.first!
    @Published var showColorOptions = false
    @Environment(\.dismiss) private var dismiss

    let shift: Shift

    private var user: User {
        User.main
    }

    init(shift: Shift) {
        self.shift = shift
    }

    var pastBlocks: [TimeBlock] {
        guard let blocks = user.timeBlocks?.allObjects as? [TimeBlock] else {
            return []
        }
        if !title.isEmpty {
            return blocks
                .filter { thisBlock in
                    let thisTitle = thisBlock.title ?? ""
                    return thisTitle.contains(title)
                }
                .sorted { $0.dateCreated ?? .distantPast > $1.dateCreated ?? .distantPast }
        }
        return blocks
    }

    var titles: [String] {
        var retArr: [String] = []
        for block in pastBlocks {
            guard let title = block.title else { continue }
            if retArr.contains(title) { continue }
            retArr.append(title)
        }
        return retArr
    }

    func saveAction(context: NSManagedObjectContext) {
        do {
            try TimeBlock(title: title,
                          start: start,
                          end: end,
                          colorHex: selectedColorHex,
                          shift: shift,
                          user: user,
                          context: context)
            dismiss()
        } catch {
            print("Error saving time block")
        }
    }
}
