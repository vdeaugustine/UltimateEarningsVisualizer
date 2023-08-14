//
//  ExpenseDetailViewModel.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/14/23.
//

import AlertToast
import Foundation
import SwiftUI

class ExpenseDetailViewModel: ObservableObject {
    init(expense: Expense) {
        self.expense = expense
    }

    @ObservedObject var user: User = User.main
    @ObservedObject var settings: Settings = User.main.getSettings()
    @ObservedObject var expense: Expense

    @Published var presentConfirmation = false
    @Published var showSheet = false
    @Published var showImageSelector = false
    @Published var shownImage: UIImage? = nil
    @Published var initialImage: UIImage? = nil
    @Published var showAlert = false
    @Published var toastConfiguration: AlertToast = AlertToast(type: .regular)
    @Published var isShowingFullScreenImage = false
    @Published var isBlurred = false
    @Published var showSpinner = false
    @Published var viewIDForReload: UUID = UUID()
    @Published var showContributions: Bool = false
    @Published var showTags: Bool = false

    @Published var contributionsRectHeight: CGFloat = 150
    @Published var tagsRectHeight: CGFloat = 150

    @Published var contributionsID = UUID()

    @Published var idToScrollTo: UUID = UUID()

    var contributionsRectIncreaseAmount: CGFloat {
        let multiplier: Double = showContributions ? 1 : -1
        return 250 * multiplier
    }

    var tagsRectIncreaseAmount: CGFloat {
        let multiplier: Double = showTags ? 1 : -1
        return 250 * multiplier
    }

    func onAppearAction() {
        initialImage = expense.loadImageIfPresent()
        shownImage = expense.loadImageIfPresent()
    }

    func expenseDetailHeaderAction() {
        showImageSelector.toggle()
        showSpinner = true
    }

    func deleteExpenseTapped() {
        presentConfirmation.toggle()
    }

    func doDeleteAction() {
        guard let context = user.managedObjectContext else {
            return
        }

        do {
            context.delete(expense)
            try context.save()
        } catch {
            print("Failed to delete")
        }
    }

    var blurRadius: CGFloat {
        isBlurred || showSpinner ? 10 : 0
    }

    func saveButtonAction() {
        if let shownImage {
            do {
                try expense.saveImage(image: shownImage)
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
        let seconds = expense.timeRemaining
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

    var contributionsButtonText: String {
        showContributions ? "Hide" : "Show"
    }

    var tagsButtonText: String {
        showTags ? "Hide" : "Show"
    }

    func styledButton<Av: Equatable>(_ text: String, width: CGFloat = 120, height: CGFloat = 35, animationValue: Av, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(text)
                .fontWeight(.semibold)
                .padding()
                .foregroundStyle(Color.white)
                .frame(width: width, height: height)
                .background {
                    Capsule(style: .circular)
                }
                .animation(.none, value: animationValue)
        }
        .padding(.bottom, 5)
    }
}
