//
//  NewItemViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/5/23.
//

import Foundation
import SwiftUI
class NewItemViewModel: ObservableObject {
    static var shared = NewItemViewModel.init()
    
    @ObservedObject var settings = User.main.getSettings()
    @ObservedObject var user = User.main
    @ObservedObject var navManager = NavManager.shared
    @Published var enteredStr = ""
    @Published var selectedType: SelectedType = .expense
    

    enum SelectedType: String, CaseIterable, Hashable, Identifiable {
        case expense, goal
        case saved = "Saved Item"
        var id: Self { self }
    }

    let numbers = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

    var toTime: Double {
        user.convertMoneyToTime(money: dubValue)
    }

    var dubValue: Double {
        (Double(enteredStr) ?? 0) / 100
    }

    var formattedString: String {
        dubValue.money(trimZeroCents: false)
    }

    var timeLabelPrefix: String {
        if selectedType == .saved {
            return "Working time saved:"
        }
        return "Time required to pay off"
    }

    var isPayoff: Bool {
        selectedType != .saved
    }

    var navLinkForNextView: some View {
        VStack {
            if selectedType == .expense {
                CreateExpenseView()
                    .environmentObject(self)
            }
            if selectedType == .goal {
                CreateGoalView()
                    .environmentObject(self)
            }
            if selectedType == .saved {
                CreateSavedView()
                    .environmentObject(self)
            }
        }
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
        selectedType = type
    }

    func append(_ num: Int) {
        if enteredStr.count < 14 {
            enteredStr += "\(num)"
        }
    }
    
    func getViewType() -> NavManager.AllViews {
        switch selectedType {
            case .expense:
                return .createExpense
            case .goal:
                return .createGoal
            case .saved:
                return .createSaved
        }
    }
}
