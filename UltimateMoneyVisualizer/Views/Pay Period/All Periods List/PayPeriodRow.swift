//
//  PayPeriodRow.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/19/23.
//

import SwiftUI

// MARK: - PayPeriodRow

struct PayPeriodRow: View {
    let payPeriod: PayPeriod
    let isCurrent: Bool
    @ObservedObject private var settings: Settings = User.main.getSettings()
    var body: some View {
        Button {
            NavManager.shared.appendCorrectPath(newValue: .payPeriodDetail(payPeriod))
        } label: {
            HStack {
                
                VStack {
                    Text("\(payPeriod.getShifts().count)")
                    Text("shifts")
                        .font(.caption2)
                }
                .foregroundStyle(.white)
                .padding(7)
                .background {
                    settings.themeColor.clipShape(RoundedRectangle(cornerRadius: 6))
                }
                
                VStack (alignment: .leading, spacing: 2) {
                    HStack(spacing: 3) {
                        Text(payPeriod.getFirstDate().getFormattedDate(format: "MMM d"))
                        Text("-")
                        Text(payPeriod.getLastDate().getFormattedDate(format: "d, y"))
                    }
                    .font(.headline)
                    
                    if isCurrent {
                        Text("current")
                            .font(.caption2)
                            .foregroundStyle(Color.green)
                            .padding(5, 2)
                            .background {
                                Color.green.opacity(0.25).clipShape(Capsule(style: .circular))
                            }
                    }
    //                Text("\(payPeriod.getShifts().count) scheduled shifts")
    //                    .font(.subheadline)
                }

                Spacer()
                
                Text(payPeriod.getCadence().rawValue).font(.subheadline)
            }
            .padding(5, 5)
            .frame(maxWidth: .infinity, maxHeight: 70, alignment: .leading)
        }
        .foregroundStyle(.black)
    }
}

// MARK: - PayPeriodRow_Previews

struct PayPeriodRow_Previews: PreviewProvider {
    static let user: User = {
        let user = User.main
        user.instantiateExampleItems(context: PersistenceController.context)
        return user
    }()

    static var previews: some View {
        ZStack {
            Color.secondarySystemBackground.frame(maxWidth: .infinity, maxHeight: .infinity)
            PayPeriodRow(payPeriod: user.getPayPeriods().first!, isCurrent: true)
                .background(.white)
        }
    }
}
