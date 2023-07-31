//
//  Wage.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/31/23.
//

import Foundation
import SwiftUI

// MARK: - WageBreakdown_NewHomeView

struct WageBreakdown_NewHomeView: View {
    @ObservedObject var user = User.main
    @State private var taxesToggleOn = false

    var body: some View {
        VStack(spacing: 16) {
            header
            rect
        }
        .padding()
    }

    var header: some View {
        HStack {
            // SectionHeader-HomeView
            Text("Wage Breakdown")
                .format(size: 16, weight: .semibold, color: .textPrimary)

            Spacer()

            Text((taxesToggleOn ? "After" : "Before") + " Taxes")
                .format(size: 12,
                        weight: .regular,
                        color: taxesToggleOn ? .textOnColor : .textPrimary)
                .padding(8, 2)
                .background {
                    { taxesToggleOn ? Color.black : Color.white }()
                        .clipShape(Capsule())
                }
                .overlay {
                    Capsule().stroke(Color.gray, style: /*@START_MENU_TOKEN@*/StrokeStyle()/*@END_MENU_TOKEN@*/)
                }
                .offset(y: 2)
                .onTapGesture {
                    taxesToggleOn.toggle()
                }
        }
    }

    var rect: some View {
        VStack(spacing: 20) {
            headerInRect
            bodyInfoPart
        }
        .padding()

        .background {
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 6)
        }
    }

    var headerInRect: some View {
        HStack {
            Text("Period")
                .format(size: 12, weight: .bold, color: Color(red: 0.37, green: 0.37, blue: 0.37))
            Spacer()
            Text("Amount")
                .format(size: 12, weight: .bold, color: Color(red: 0.37, green: 0.37, blue: 0.37))
        }
    }

    var bodyInfoPart: some View {
        VStack {
            row(period: "Yearly",
                amount: user.getWage().perYear * (taxesToggleOn ? (1 - user.getWage().totalTaxMultiplier) : 1))
            Divider()
            row(period: "Month", amount: user.getWage().perMonth * (taxesToggleOn ? (1 - user.getWage().totalTaxMultiplier) : 1))
            Divider()
            row(period: "Week", amount: user.getWage().perWeek * (taxesToggleOn ? (1 - user.getWage().totalTaxMultiplier) : 1))
            Divider()
            row(period: "Day", amount: user.getWage().perDay * (taxesToggleOn ? (1 - user.getWage().totalTaxMultiplier) : 1))
            Divider()
            row(period: "Hour", amount: user.getWage().hourly * (taxesToggleOn ? (1 - user.getWage().totalTaxMultiplier) : 1))
            Divider()
            row(period: "Minute", amount: user.getWage().perMinute * (taxesToggleOn ? (1 - user.getWage().totalTaxMultiplier) : 1))
            Divider()
            row(period: "Second",
                amount: user.getWage().perSecond * (taxesToggleOn ? (1 - user.getWage().totalTaxMultiplier) : 1),
                extend: true)
        }
    }

    func row(period: String, amount: Double, extend: Bool = false) -> some View {
        HStack {
            Text(period)
                .format(size: 12, weight: .regular, color: .textPrimary)
            Spacer()
            Text({ extend ? amount.moneyExtended(decimalPlaces: 4) :
                    amount.money() }())
                .format(size: 12, weight: .regular, color: .textPrimary)
        }
    }
}

// MARK: - WageBreakdown_NewHomeView_Previews

struct WageBreakdown_NewHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WageBreakdown_NewHomeView()
//            .padding()
            .templateForPreview()
    }
}
