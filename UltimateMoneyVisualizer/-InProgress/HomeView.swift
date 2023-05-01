//
//  HomeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI

// MARK: - HomeView

struct HomeView: View {
    @ObservedObject private var settings = User.main.getSettings()
    @ObservedObject private var user = User.main

    var body: some View {
        
        ZStack {
            
            ScrollView {
                
                // MARK: - Lifetime Money
                VStack {
                    HStack {
                        Text("Lifetime")
                            .font(.headline)
                        Spacer()
                        NavigationLink {
                            
                        } label: {
                            Text("Stats")
                                .font(.subheadline)
                                .padding(.trailing)
                        }
                    }
                    
                    NavigationLink {
                        ShiftListView()
                    } label: {
                        HorizontalDataDisplay(data: [.init(label: "earnings", value: user.totalEarned().formattedForMoney()),
                                                     .init(label: "time worked", value: user.totalWorked().formatForTime()),
                                                     .init(label: "time saved", value: user.totalDollarsSaved().formatForTime())])
                            .centerInParentView()
                    }
                    .buttonStyle(.plain)
                }
                
                
                
                
            }
            
            
        }
        
        
//        List {
//            Text("Wage")
//                .spacedOut(text: user.wage?.amount.formattedForMoney() ?? "NA")
//            Text("Total Worked")
//                .spacedOut(text: Shift.totalDuration(for: user).formatForTime([.day, .hour]))
//            Text("Total Earned")
//                .spacedOut(text: user.totalEarned().formattedForMoney())
//
//            Section {
//                NavigationLink("Saved Items") {
//                    SavedListView()
//                }
//            }
//
//            Section {
//                NavigationLink("Expenses") {
//                    ExpenseListView()
//                }
//            }
//        }
        .putInTemplate()
    }

    func newSection<Content: View>(rectContainer: Bool = true,
                                   header: String,
                                   @ViewBuilder content: @escaping () -> Content)
        -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(header)
                .font(.headline)
            if rectContainer {
                content()
                    .centerInParentView()
                    .rectContainer(shadowRadius: 1, cornerRadius: 8)

            } else {
                content()
                    .centerInParentView()
            }
        }
    }

    func newSection<Nav: View, Content: View>(rectContainer: Bool = true,
                                              @ViewBuilder header: @escaping () -> Nav,
                                              @ViewBuilder content: @escaping () -> Content)
        -> some View {
        VStack(alignment: .leading, spacing: 7) {
            header()
            if rectContainer {
                content()
                    .centerInParentView()
                    .rectContainer(shadowRadius: 1, cornerRadius: 8)

            } else {
                content()
                    .centerInParentView()
            }
        }
    }
}

// MARK: - HomeView_Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
