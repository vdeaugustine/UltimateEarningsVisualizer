//
//  FloatingButtonView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/4/23.
//

import FloatingButton
import SwiftUI

// MARK: - FloatingPlusButton

struct FloatingPlusButton: View {
    @ObservedObject private var settings = User.main.getSettings()
    @Binding var isShowing: Bool

    let expense = MainMenuRow(title: "Expense", iconString: IconManager.expenseString) {
        NavManager.shared.appendCorrectPath(newValue: .createExpense)
    }
    let goal = MainMenuRow(title: "Goal", iconString: IconManager.goalsString) {
        NavManager.shared.appendCorrectPath(newValue: .createGoal)
    }
    let savedItem = MainMenuRow(title: "Saved") {
        NavManager.shared.appendCorrectPath(newValue: .createSaved)
    } icon: {
        IconManager.savedIcon.stroke(lineWidth: 1.5).aspectRatio(contentMode: .fit)
    }

    let shift = MainMenuRow(title: "Shift", iconString: IconManager.shiftsString) {
        NavManager.shared.appendCorrectPath(newValue: .createShift)
    }

    var body: some View {
        VStack {
            FloatingButton(mainButtonView: mainView, buttons: [expense, goal, savedItem, shift], isOpen: $isShowing)
                .straight()
                .direction(.top)
                .initialOpacity(0)
                .alignment(.right)
        }
    }

    var mainView: some View {
        VStack {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .background(Circle().fill(.white))
                .foregroundStyle(settings.getDefaultGradient())
                .rotationEffect(.degrees(isShowing ? 315 : 0))
                .animation(.default, value: isShowing)
        }
    }
}

// MARK: - MainMenuRow

struct MainMenuRow: View {
    let title: String

    let icon: () -> AnyView
    let height: CGFloat

    let action: () -> Void

    init(title: String, height: CGFloat = 40, action: @escaping () -> Void, @ViewBuilder icon: @escaping () -> any View) {
        self.title = title
        self.icon = { icon().anyView }
        self.height = height
        self.action = action
    }

    init(title: String, height: CGFloat = 40, iconString: String, action: @escaping () -> Void) {
        self.title = title
        self.icon = {
            Image(systemName: iconString)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .font(.subheadline)
                .anyView
        }
        self.height = height
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
    //            Spacer()
                icon()
                    .frame(maxWidth: height - 15)
                Text(title)
            }
            .font(.subheadline)
            .foregroundStyle(Color(uiColor: .secondaryLabel))
            .padding(7)
            .frame(width: 115, height: height, alignment: .leading)
            .background { Color.listBackgroundColor }
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
            .shadow(radius: 0.5)
        }
    }
}

// MARK: - FloatingButtonView_Previews

struct FloatingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingPlusButton(isShowing: .constant(true))
        MainMenuRow(title: "Expenses", iconString: IconManager.expenseString) {}
    }
}
