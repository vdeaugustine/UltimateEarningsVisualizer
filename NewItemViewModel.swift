//
//  NewItemViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/5/23.
//

import Foundation
import SwiftUI
class NewItemViewModel: ObservableObject {
    @Published var enteredStr = ""
    @Published var selectedType: SelectedType = .expense

    enum SelectedType: String, CaseIterable, Hashable, Identifiable {
        case expense, goal
        case saved = "Saved Item"
        var id: Self { self }
    }

    @ObservedObject var settings = User.main.getSettings()
    @ObservedObject var user = User.main

    let numbers = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

    var isPayoff: Bool {
        selectedType != .saved
    }

    func color(_ type: SelectedType) -> Color {
        selectedType == type ? .init(hex: "E8F0FE") : .clear
    }

    func foreground(_ type: SelectedType) -> Color {
        selectedType == type ? Color(hex: "2867D2") : Color(hex: "202124")
    }

    func borderColor(_ type: SelectedType) -> Color {
        selectedType == type ? Color.clear : Color(hex: "DADCE0")
    }

    func tapAction(_ type: SelectedType) {
//        withAnimation {
        selectedType = type
//        }
    }

    var toTime: Double {
        user.convertMoneyToTime(money: dubValue)
    }

    var dubValue: Double {
        (Double(enteredStr) ?? 0) / 100
    }

    var formattedString: String {
        dubValue.formattedForMoney(trimZeroCents: false)
    }

    var timeLabelPrefix: String {
        if selectedType == .saved {
            return "Working time saved:"
        }
        return "Time required to pay off"
    }

    func append(_ num: Int) {
        if enteredStr.count < 14 {
            enteredStr += "\(num)"
        }
    }

    func saveAction() throws {
//        switch selectedType {
//            case .expense:
//                try Expense(
//                    title: <#T##String#>,
//                    info: <#T##String?#>,
//                    amount: <#T##Double#>,
//                    dueDate: <#T##Date?#>,
//                    dateCreated: <#T##Date?#>,
//                    isRecurring: <#T##Bool#>,
//                    recurringDate: <#T##Date?#>,
//                    tagStrings: <#T##[String]?#>,
//                    user: user,
//                    context: user.getContext()
//                )
//            case .goal:
//                <#code#>
//            case .saved:
//                <#code#>
//        }
    }
}
