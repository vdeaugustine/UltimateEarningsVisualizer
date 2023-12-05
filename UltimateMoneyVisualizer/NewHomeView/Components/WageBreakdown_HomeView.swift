//
//  Wage.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/31/23.
//

import Foundation
import SwiftUI

// MARK: - WageBreakdown_NewHomeView

struct WageBreakdown_HomeView: View {
    @EnvironmentObject private var vm: NewHomeViewModel

    var body: some View {
        VStack(spacing: 16) {
            header
            rect
        }
        .padding()
        .onTapGesture {
            vm.navManager.appendCorrectPath(newValue: .wage)
        }
    }

    var header: some View {
        HStack {
            // SectionHeader-HomeView
            Text("Wage Breakdown")
                .font(.callout)
                .fontWeight(.semibold)
//                .foregroundStyle(Color.textPrimary)

            Spacer()

            Text("Taxes")
                .foregroundStyle(vm.taxesToggleOn ? Color.textOnColor : Color.textPrimary)
                .font(.subheadline)
//                .format(size: 14,
//                        weight: .regular,
//                        color: vm.taxesToggleOn ? .textOnColor : .textPrimary)
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
        .modifier(ShadowForRect())
    }

    var headerInRect: some View {
        HStack {
            Text("Period")
//                .format(size: 12,
//                        weight: .bold,
//                        color: Color(red: 0.37,
//                                     green: 0.37,
//                                     blue: 0.37))
            Spacer()
            Text("Amount")
//                .format(size: 12,
//                        weight: .bold,
//                        color: Color(red: 0.37,
//                                     green: 0.37,
//                                     blue: 0.37))
        }
        .font(.headline)
        .foregroundStyle(UIColor.secondaryLabel.color)
    }

    var bodyInfoPart: some View {
        VStack {
            Group {
                row(period: "Year",
                    amount: vm.wage.perYear * (vm.taxesToggleOn ? (1 - vm.wage.totalTaxMultiplier) : 1))
                Divider()
                row(period: "Month",
                    amount: vm.wage.perMonth * (vm.taxesToggleOn ? (1 - vm.wage.totalTaxMultiplier) : 1))
                Divider()
                row(period: "Week",
                    amount: vm.wage.perWeek * (vm.taxesToggleOn ? (1 - vm.wage.totalTaxMultiplier) : 1))
                Divider()
                row(period: "Day",
                    amount: vm.wage.perDay * (vm.taxesToggleOn ? (1 - vm.wage.totalTaxMultiplier) : 1))
                Divider()
                row(period: "Hour",
                    amount: vm.wage.hourly * (vm.taxesToggleOn ? (1 - vm.wage.totalTaxMultiplier) : 1))
            }
            Divider()
            row(period: "Minute",
                amount: vm.wage.perMinute * (vm.taxesToggleOn ? (1 - vm.wage.totalTaxMultiplier) : 1))
            Divider()
            row(period: "Second",
                amount: vm.wage.perSecond * (vm.taxesToggleOn ? (1 - vm.wage.totalTaxMultiplier) : 1),
                extend: true)
        }
    }

    func row(period: String, amount: Double, extend: Bool = false) -> some View {
        HStack {
            Text(period)
//                .format(size: 12,
//                        weight: .regular,
//                        color: .textPrimary)
            Spacer()
            Text({ extend ? amount.moneyExtended(decimalPlaces: 4) : amount.money() }())
//                .format(size: 12,
//                        weight: .regular,
//                        color: .textPrimary)
        }
        .font(.subheadline)
    }
}

// MARK: - WageBreakdown_NewHomeView_Previews

struct WageBreakdown_NewHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WageBreakdown_HomeView()
            .templateForPreview()
            .environmentObject(NewHomeViewModel.shared)
    }
}
