//
//  TotalItem.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/30/23.
//

import SwiftUI

// MARK: - TotalItem

struct TotalItem: View {
    let imageName: String
    let amount: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: imageName)
                .font(.system(size: 24))
            Text(amount)
                .font(
                    Font.custom(Font.robotoRegular, size: 16)
                        .weight(.semibold)
                )
                .foregroundColor(Color(red: 0.13, green: 0.13, blue: 0.13))
            Text(description)
                .font(Font.custom(Font.robotoRegular, size: 12))
                .foregroundColor(Color(red: 0.37, green: 0.37, blue: 0.37))
        }
    }
}

// MARK: - TotalsHeader

struct TotalsHeader: View {
    var body: some View {
        HStack {
            Text("Totals to Date")
                .format(size: 16, weight: .semibold)
            Spacer()
            Text("More Stats")
                .format(size: 14, weight: .medium, color: .textSecondary)
        }
    }
}

// MARK: - TotalsToDate_HomeView

struct TotalsToDate_HomeView: View {
    var body: some View {
        VStack(spacing: 30) {
            TotalsHeader()
            VStack(spacing: 14) {
                HStack {
                    TotalItem(imageName: "chart.bar", amount: "$57,291", description: "Earned")
                    Spacer()
                    TotalItem(imageName: "cart", amount: "$57,291", description: "Paid off")
                    Spacer()
                    TotalItem(imageName: "creditcard.and.123", amount: "$57,291", description: "Taxes")
                }

                HStack {
                    TotalItem(imageName: "chart.bar", amount: "$57,291", description: "Expenses")
                    Spacer()
                    TotalItem(imageName: "cart", amount: "$57,291", description: "Goals")
                    Spacer()
                    TotalItem(imageName: "creditcard.and.123", amount: "$57,291", description: "Saved")
                }
            }
            .frame(maxWidth: 285)
        }
        .padding(.horizontal)
    }
}

// MARK: - TotalItem_Previews

struct TotalItem_Previews: PreviewProvider {
    static var previews: some View {
        TotalItem(imageName: "chart.bar", amount: "$1,234", description: "Total spent")
    }
}
