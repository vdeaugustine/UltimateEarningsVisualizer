////
////  WageBreakdownBox.swift
////  UltimateMoneyVisualizer
////
////  Created by Vincent DeAugustine on 5/3/23.
////
//
//import SwiftUI
//
//struct WageBreakdownBox: View {
//    
//    @ObservedObject private var user = User.main
//    @ObservedObject private var settings = User.main.settings
//    
//    var body: some View {
//        homeSection {
//            Text("Wage")
//                .font(.headline)
//                .spacedOut {
//                    NavigationLink {
//                        EnterWageView()
//                    } label: {
//                        Image(systemName: "ellipsis")
//                            .font(.subheadline)
//                            .padding(.trailing)
//                    }
//                }
//        } content: {
//            VStack(spacing: 10) {
//                Text("Period")
//                    .font(.headline)
//                    .fontWeight(.medium)
//                    .spacedOut {
//                        Text("Amount")
//                            .font(.headline)
//                            .fontWeight(.medium)
//                    }
//                VStack {
//                    Group {
//                        Text("Year")
//                            .spacedOut(text: model.wage.amountPerYear().formattedForMoney())
//                        Divider()
//                        Text("Month")
//                            .spacedOut(text: model.wage.amountPerMonth().formattedForMoney())
//                        Divider()
//                        Text("Week")
//                            .spacedOut(text: model.wage.amountPerWeek().formattedForMoney())
//                        Divider()
//                        Text("Day")
//                            .spacedOut(text: model.wage.amountPerDay().formattedForMoney())
//                        Divider()
//                        Text("Hour")
//                            .spacedOut(text: model.wage.amountPerHour().formattedForMoney())
//                    }
//                    Divider()
//                    Text("Minute")
//                        .spacedOut(text: model.wage.amountPerMinute().formattedForMoneyExtended())
//                    Divider()
//                    Text("Second")
//                        .spacedOut(text: model.wage.amountPerSecond().formattedForMoneyExtended())
//                }
//                .font(.subheadline)
//            }
//            .padding()
//    }
//}
//
//struct WageBreakdownBox_Previews: PreviewProvider {
//    static var previews: some View {
//        WageBreakdownBox()
//    }
//}
