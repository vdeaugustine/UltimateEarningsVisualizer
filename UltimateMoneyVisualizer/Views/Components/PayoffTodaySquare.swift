//
//  PayoffTodaySquare.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/8/23.
//

import SwiftUI

// MARK: - PayoffTodaySquare

struct PayoffTodaySquare: View {
    @ObservedObject private var settings = User.main.getSettings()
    @ObservedObject private var user = User.main

    let item: TempTodayPayoff

    init(item: TempTodayPayoff) {
        self.item = item
        self.title = item.title
        self.itemTotal = item.amount
        self.progressAmount = item.progressAmount
        self.havedPaidOff = item.amountPaidOff
        self.payoffType = item.type
    }

    let title: String
    let itemTotal: Double
    let progressAmount: Double
//    let payoffItem: PayoffItem
    let havedPaidOff: Double

    var progressToShow: Double {
        progressAmount > 0 ? progressAmount : 0
    }

    let payoffType: PayoffType

    var percent: Double {
        havedPaidOff / itemTotal
    }

    var correspondingGoal: Goal? {
        user.getGoals().first(where: { $0.getID() == item.id })
    }

    var correspondingExpense: Expense? {
        user.getExpenses().first(where: { $0.getID() == item.id })
    }

    var gradient: LinearGradient {
        
        item.type == .tax ? Color.niceRed.getGradient() : settings.getDefaultGradient()
    }

    var mainContent: some View {
        VStack {
            HStack {
                ProgressCircle(percent: percent,
                               widthHeight: 75,
                               gradient: gradient,
                               lineWidth: 5) {
                    VStack(spacing: 2) {
                        Text(havedPaidOff.money())
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(gradient)

                        Text(progressToShow.money(includeCents: true).replacingOccurrences(of: "$", with: "+"))
                            .font(.caption2)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }
                    .offset(y: 5)
                    .padding(.horizontal, 2)
                }

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    HStack(alignment: .bottom, spacing: 5) {
                        Text(itemTotal.money())
                            .lineLimit(1)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(gradient)
                    }

                    Text(payoffType.rawValue.uppercased())
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.gray)
                }
            }
        }
    }

    var body: some View {
        if let correspondingGoal {
            NavigationLink {
                GoalDetailView(goal: correspondingGoal)
            } label: {
                mainContent
            }
        } else if let correspondingExpense {
            NavigationLink {
                ExpenseDetailView(expense: correspondingExpense)
            } label: {
                mainContent
            }
        } else {
            mainContent
        }
    }
}

// MARK: - PayoffTodaySquare_Previews

struct PayoffTodaySquare_Previews: PreviewProvider {
    static var item: PayoffItem {
        User.main.getQueue().first!
    }

    static var previews: some View {
        PayoffTodaySquare(item: .init(payoff: item))
            .frame(width: UIScreen.main.bounds.width / 2 - 10)
            .previewLayout(.sizeThatFits)
    }
}
