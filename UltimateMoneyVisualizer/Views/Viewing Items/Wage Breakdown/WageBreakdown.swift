//
//  WageBreakdown.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/14/23.
//

import SwiftUI

// MARK: - WageBreakdown

struct WageBreakdown: View {
    @ObservedObject var wage: Wage
    @State var toggleTaxes: Bool
    let includeHeader: Bool
    let includePadding: Bool

    var body: some View {
        VStack(spacing: 16) {
            if includeHeader {
                header
            }

            rect
        }
        .conditionalModifier(includePadding) { thisView in
            thisView.padding()
        }
    }

    var header: some View {
        HStack {
            // SectionHeader-HomeView
            Text("Wage Breakdown")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(Color.textPrimary)

            Spacer()

            Text("Taxes")
                .font(.footnote)
                .foregroundStyle(toggleTaxes ? Color.textOnColor : Color.textPrimary)
                .padding(8, 2)
                .background {
                    { toggleTaxes ? Color.black : Color.white }()
                        .clipShape(Capsule())
                }
                .overlay {
                    Capsule().stroke(Color.gray, style: /*@START_MENU_TOKEN@*/StrokeStyle()/*@END_MENU_TOKEN@*/)
                }
                .offset(y: 2)
                .onTapGesture {
                    toggleTaxes.toggle()
                }
        }
    }

    var rect: some View {
        VStack(spacing: 20) {
            headerInRect
            bodyInfoPart
        }
        .padding()
        .modifier(ShadowForRect())
    }

    var headerInRect: some View {
        HStack {
            Text("Period")
                .format(size: 12,
                        weight: .bold,
                        color: Color(red: 0.37,
                                     green: 0.37,
                                     blue: 0.37))
            Spacer()
            Text("Amount")
                .format(size: 12,
                        weight: .bold,
                        color: Color(red: 0.37,
                                     green: 0.37,
                                     blue: 0.37))
        }
    }

    var bodyInfoPart: some View {
        VStack {
            row(period: "Yearly",
                amount: wage.perYear * (toggleTaxes ? (1 - wage.totalTaxMultiplier) : 1))
            Divider()
            row(period: "Month",
                amount: wage.perMonth * (toggleTaxes ? (1 - wage.totalTaxMultiplier) : 1))
            Divider()
            row(period: "Week",
                amount: wage.perWeek * (toggleTaxes ? (1 - wage.totalTaxMultiplier) : 1))
            Divider()
            row(period: "Day",
                amount: wage.perDay * (toggleTaxes ? (1 - wage.totalTaxMultiplier) : 1))
            Divider()
            row(period: "Hour",
                amount: wage.hourly * (toggleTaxes ? (1 - wage.totalTaxMultiplier) : 1))
            Divider()
            row(period: "Minute",
                amount: wage.perMinute * (toggleTaxes ? (1 - wage.totalTaxMultiplier) : 1))
            Divider()
            row(period: "Second",
                amount: wage.perSecond * (toggleTaxes ? (1 - wage.totalTaxMultiplier) : 1),
                extend: true)
        }
    }

    func row(period: String, amount: Double, extend: Bool = false) -> some View {
        HStack {
            Text(period)
                .format(size: 12,
                        weight: .regular,
                        color: .textPrimary)
            Spacer()
            Text({ extend ? amount.moneyExtended(decimalPlaces: 4) : amount.money() }())
                .format(size: 12,
                        weight: .regular,
                        color: .textPrimary)
        }
    }
}

// MARK: - WageBreakdown_Previews

struct WageBreakdown_Previews: PreviewProvider {
    static var previews: some View {
        WageBreakdown(wage: User.main.getWage(),
                      toggleTaxes: true,
                      includeHeader: true,
                      includePadding: true)
    }
}
