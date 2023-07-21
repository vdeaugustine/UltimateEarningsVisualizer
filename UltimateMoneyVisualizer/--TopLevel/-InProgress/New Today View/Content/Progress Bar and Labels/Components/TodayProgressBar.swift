//
//  TodayProgressBar.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

// MARK: - TodayProgressBar

struct TodayProgressBar: View {
    @EnvironmentObject private var viewModel: TodayViewModel
    let barHeights: CGFloat = 16

    struct DataItem: Hashable {
        let title: String
        let amount: Double
        let color: Color
    }

    var data: [DataItem] {
        [DataItem(title: "Taxes",
                  amount: viewModel.taxesPaidSoFar,
                  color: viewModel.taxesColor),
//         DataItem(title: "Will Spend on Taxes",
//                  amount: viewModel.wage.totalTaxMultiplier * viewModel.willEarn,
//                  color: viewModel.taxesColor.opacity(0.6)),
         DataItem(title: "Expenses",
                  amount: viewModel.spentOnExpenses,
                  color: viewModel.expensesColor),
         DataItem(title: "Goals",
                  amount: viewModel.spentOnGoals,
                  color: viewModel.goalsColor),

         DataItem(title: "Unspent",
                  amount: viewModel.unspent,
                  color: viewModel.unspentColor),
         DataItem(title: "Remaining to earn",
                  amount: viewModel.willEarn - viewModel.haveEarned,
                  color: Color(uiColor: .lightGray))]
            .filter { $0.amount > 0 }
    }

    var testData: [DataItem] {
        [DataItem(title: "Expenses", amount: 100.0, color: .blue),
         DataItem(title: "Goals", amount: 200.0, color: .green),
         DataItem(title: "Taxes", amount: 50.0, color: .red),
         DataItem(title: "Will Spend on Taxes", amount: 75.0, color: .orange),
         DataItem(title: "Unspent", amount: 300.0, color: .purple)]
            .filter { $0.amount > 0 }
    }

    var useData: [DataItem] { data }

    var totalAmount: Double {
        return useData.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .foregroundColor(Color(uiColor: .lightGray))
                    .frame(width: geo.size.width)

                HStack(spacing: 0) {
                    ForEach(useData, id: \.self) { datum in
                        Rectangle()
                            .foregroundColor(datum.color)
                            .frame(width: CGFloat(datum.amount / viewModel.willEarn) * geo.size.width)
                    }
                }
            }
        }
        .cornerRadius(15)
        .frame(height: 16)
        .padding()
        .background {
            Color.white
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 4)
                .frame(height: 60)
        }
    }
}

// MARK: - TodayProgressBar_Previews

struct TodayProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.targetGray
            TodayProgressBar()
                .environmentObject(TodayViewModel.main)
        }
    }
}
