//
//  WageBreakdownBox.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/3/23.
//

import SwiftUI

// MARK: - WageBreakdownBox

struct WageBreakdownBox: View {
    @ObservedObject private var user = User.main
    @ObservedObject private var wage = User.main.getWage()

    var body: some View {
        homeSection {
            Text("Wage")
                .font(.headline)
                .spacedOut {
                    NavigationLink {
                        EnterWageView()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.subheadline)
                            .padding(.trailing)
                    }
                }
        } content: {
            VStack(spacing: 10) {
                HStack {
                    Text("Period")
                        .font(.headline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("Before Tax")
                        .font(.headline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("After Tax")
                        .font(.headline)
                        .fontWeight(.medium)
                }
                
                HStack {
                    VStack {
                        Group {
                            Text("Year")
                                .spacedOut(text: wage.perYear.formattedForMoney())
                            Divider()
                            Text("Month")
                                .spacedOut(text: wage.perMonth.formattedForMoney())
                            Divider()
                            Text("Week")
                                .spacedOut(text: wage.perWeek.formattedForMoney())
                            Divider()
                            Text("Day")
                                .spacedOut(text: wage.perDay.formattedForMoney())
                            Divider()
                            Text("Hour")
                                .spacedOut(text: wage.hourly.formattedForMoney())
                        }
                        Divider()
                        Text("Minute")
                            .spacedOut(text: wage.perMinute.formattedForMoney())
                        Divider()
                        Text("Second")
                            .spacedOut(text: wage.perSecond.formattedForMoney())
                    }
                    .font(.subheadline)
                }
                
                
//                Text("Period")
//                    .font(.headline)
//                    .fontWeight(.medium)
//                    .spacedOut {
//                        Text("Amount")
//                            .font(.headline)
//                            .fontWeight(.medium)
//                    }
                
            }
            .padding()
        }
    }
}

// MARK: - WageBreakdownBox_Previews

struct WageBreakdownBox_Previews: PreviewProvider {
    static var previews: some View {
        WageBreakdownBox()
            .previewLayout(.sizeThatFits)
    }
}
