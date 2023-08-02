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
    @EnvironmentObject private var vm: NewHomeViewModel

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

            Text((vm.taxesToggleOn ? "After" : "Before") + " Taxes")
                .format(size: 12,
                        weight: .regular,
                        color: vm.taxesToggleOn ? .textOnColor : .textPrimary)
                .padding(8, 2)
                .background {
                    { vm.taxesToggleOn ? Color.black : Color.white }()
                        .clipShape(Capsule())
                }
                .overlay {
                    Capsule().stroke(Color.gray, style: /*@START_MENU_TOKEN@*/StrokeStyle()/*@END_MENU_TOKEN@*/)
                }
                .offset(y: 2)
                .onTapGesture {
                    vm.taxesToggleOn.toggle()
                }
        }
    }

    var rect: some View {
        VStack(spacing: 20) {
            headerInRect
            bodyInfoPart
        }
        .padding()
        .modifier(NewHomeView.ShadowForRect())
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
                amount: vm.user.getWage().perYear * (vm.taxesToggleOn ? (1 - vm.user.getWage().totalTaxMultiplier) : 1))
            Divider()
            row(period: "Month",
                amount: vm.user.getWage().perMonth * (vm.taxesToggleOn ? (1 - vm.user.getWage().totalTaxMultiplier) : 1))
            Divider()
            row(period: "Week",
                amount: vm.user.getWage().perWeek * (vm.taxesToggleOn ? (1 - vm.user.getWage().totalTaxMultiplier) : 1))
            Divider()
            row(period: "Day",
                amount: vm.user.getWage().perDay * (vm.taxesToggleOn ? (1 - vm.user.getWage().totalTaxMultiplier) : 1))
            Divider()
            row(period: "Hour",
                amount: vm.user.getWage().hourly * (vm.taxesToggleOn ? (1 - vm.user.getWage().totalTaxMultiplier) : 1))
            Divider()
            row(period: "Minute",
                amount: vm.user.getWage().perMinute * (vm.taxesToggleOn ? (1 - vm.user.getWage().totalTaxMultiplier) : 1))
            Divider()
            row(period: "Second",
                amount: vm.user.getWage().perSecond * (vm.taxesToggleOn ? (1 - vm.user.getWage().totalTaxMultiplier) : 1),
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

// MARK: - WageBreakdown_NewHomeView_Previews

struct WageBreakdown_NewHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WageBreakdown_NewHomeView()
            .templateForPreview()
    }
}
