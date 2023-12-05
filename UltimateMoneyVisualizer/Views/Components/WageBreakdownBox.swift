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
                    Button {
                        NavManager.shared.appendCorrectPath(newValue: .enterWage)
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
                                .spacedOut(text: wage.perYear.money())
                            Divider()
                            Text("Month")
                                .spacedOut(text: wage.perMonth.money())
                            Divider()
                            Text("Week")
                                .spacedOut(text: wage.perWeek.money())
                            Divider()
                            Text("Day")
                                .spacedOut(text: wage.perDay.money())
                            Divider()
                            Text("Hour")
                                .spacedOut(text: wage.hourly.money())
                        }
                        Divider()
                        Text("Minute")
                            .spacedOut(text: wage.perMinute.money())
                        Divider()
                        Text("Second")
                            .spacedOut(text: wage.perSecond.money())
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
