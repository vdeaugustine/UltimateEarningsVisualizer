//
//  GoalDetailViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/10/23.
//

import AlertToast
import Foundation
import SwiftUI

class PayoffItemDetailViewModel: ObservableObject {
    // CATEGORY: Lifecycle

    init(payoffItem: PayoffItem) {
        self.payoffItem = payoffItem
        self.allocations = payoffItem.getAllocations()
        self.amountPaidOff = payoffItem.amountPaidOff
        self.amountRemaining = payoffItem.amountRemainingToPayOff
        self.tags = payoffItem.getTags()
    }

    // CATEGORY: Internal

    @ObservedObject var user: User = User.main
    @ObservedObject var settings: Settings = User.main.getSettings()

    // swiftformat:sort:begin
    @Published var allocations: [Allocation]
    @Published var amountPaidOff: Double
    @Published var amountRemaining: Double
    @Published var contributionsID = UUID()
    @Published var contributionsRectHeight: CGFloat = 150
    @Published var idToScrollTo: UUID = UUID()
    @Published var initialImage: UIImage? = nil
    @Published var isBlurred = false
    @Published var isShowingFullScreenImage = false
    @Published var payoffItem: PayoffItem
    @Published var presentConfirmation = false
    @Published var showAlert = false
    @Published var showContributions: Bool = false
    @Published var showImageSelector = false
    @Published var shownImage: UIImage? = nil
    @Published var showSheet = false
    @Published var showSpinner = false
    @Published var showTags: Bool = false
    @Published var tags: [Tag]
    @Published var tagsRectHeight: CGFloat = 150
    @Published var toastConfiguration: AlertToast = AlertToast(type: .regular)
    @Published var viewIDForReload: UUID = UUID()

    // swiftformat:sort:end

    var contributionsRectIncreaseAmount: CGFloat {
        let multiplier: Double = showContributions ? 1 : -1
        return 250 * multiplier
    }

    var tagsRectIncreaseAmount: CGFloat {
        let multiplier: Double = showTags ? 1 : -1
        return CGFloat(CGFloat(payoffItem.getTags().count) / 2) * 100 * multiplier
    }

    var blurRadius: CGFloat {
        isBlurred || showSpinner ? 10 : 0
    }

    var contributionsButtonText: String {
        showContributions ? "Hide" : "Show"
    }

    var tagsButtonText: String {
        showTags ? "Hide" : "Show"
    }

    func onAppearAction() {
        initialImage = payoffItem.loadImageIfPresent()
        shownImage = payoffItem.loadImageIfPresent()
    }

    func goalDetailHeaderAction() {
        showImageSelector.toggle()
        showSpinner = true
    }

    func deleteGoalTapped() {
        presentConfirmation.toggle()
    }

    func doDeleteAction() {
        guard let context = user.managedObjectContext else {
            return
        }
        do {
            if let goal = payoffItem as? Goal {
                context.delete(goal)
            } else if let expense = payoffItem as? Expense {
                context.delete(expense)
            }
            try context.save()
        } catch {
            print("Failed to delete")
        }
    }

    func saveButtonAction() {
        if let shownImage {
            do {
                if let goal = payoffItem as? Goal {
                    try goal.saveImage(image: shownImage)
                } else if let expense = payoffItem as? Expense {
                    try expense.saveImage(image: shownImage)
                }

                toastConfiguration = AlertToast(displayMode: .alert, type: .complete(settings.themeColor), title: "Saved successfully")
                showAlert = true
                viewIDForReload = UUID()

            } catch {
                toastConfiguration = AlertToast(displayMode: .alert, type: .error(settings.themeColor), title: "Failed to save image")
                showAlert = true
            }
        }
    }

    func contributionsButtonAction() {
        showContributions.toggle()
        contributionsRectHeight += contributionsRectIncreaseAmount
    }

    func tagsButtonAction() {
        showTags.toggle()
        tagsRectHeight += tagsRectIncreaseAmount
    }

    func breakDownTime() -> String {
        let seconds = payoffItem.timeRemaining
        let timeUnits: [(unit: String, seconds: Double)] = [("y", 365 * 24 * 60 * 60),
                                                            ("mo", 30 * 24 * 60 * 60),
                                                            ("w", 7 * 24 * 60 * 60),
                                                            ("d", 24 * 60 * 60),
                                                            ("h", 60 * 60),
                                                            ("m", 60),
                                                            ("s", 1)]

        var remainingSeconds = seconds
        var timeComponents: [String] = []

        for unit in timeUnits {
            let value = Int(remainingSeconds / unit.seconds)

            if value > 0 {
                timeComponents.append("\(value)\(unit.unit)")
                remainingSeconds -= Double(value) * unit.seconds
            }
        }

        if timeComponents.isEmpty {
            return "0s"
        } else {
            return timeComponents.joined(separator: " ")
        }
    }
}
