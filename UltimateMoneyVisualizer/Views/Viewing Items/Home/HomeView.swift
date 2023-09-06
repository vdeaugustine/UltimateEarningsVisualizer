//
//  HomeView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI
import Vin

// MARK: - HomeView

struct HomeView: View {
    @EnvironmentObject private var navManager: NavManager
    @ObservedObject private var settings = User.main.getSettings()
    @ObservedObject private var user = User.main

    @State private var currentPayoffQueueSlot: Int = 1

    var body: some View {
        VStack {
            ZStack {
                ScrollView {
                    // MARK: - Lifetime Money

                    VStack {
                        homeSection(rectContainer: false) {
                            HStack {
                                Text("Lifetime")
                                    .font(.headline)
                                Spacer()

                                NavigationLink(value: "stats") {
                                    Text("Stats")
                                        .font(.subheadline)
                                        .padding(.trailing)
                                }
                            }
                        } content: {
                            HStack {
                                NavigationLink(destination: ShiftListView()) {
                                    VStack {
                                        Text("Earnings")
                                            .fontWeight(.medium)
                                            .minimumScaleFactor(0.01)
                                        Text(user.totalEarned().money())
                                            .fontWeight(.bold)
                                            .foregroundStyle(settings.getDefaultGradient())
                                            .minimumScaleFactor(0.01)
                                    }.padding(.horizontal)
                                }.buttonStyle(PlainButtonStyle())

                                Divider()

                                NavigationLink(destination: ShiftListView()) {
                                    VStack {
                                        Text("Time Worked")
                                            .fontWeight(.medium)
                                            .minimumScaleFactor(0.01)
                                        Text(user.totalTimeWorked().formatForTime())
                                            .fontWeight(.bold)
                                            .foregroundStyle(settings.getDefaultGradient())
                                            .minimumScaleFactor(0.01)
                                    }.padding(.horizontal)
                                }.buttonStyle(PlainButtonStyle())

                                Divider()

                                NavigationLink(destination: SavedListView()) {
                                    VStack {
                                        Text("Time Saved")
                                            .fontWeight(.medium)
                                            .minimumScaleFactor(0.01)
                                        Text(user.totalTimeSaved().formatForTime())
                                            .fontWeight(.bold)
                                            .foregroundStyle(settings.getDefaultGradient())
                                            .minimumScaleFactor(0.01)
                                    }.padding(.horizontal)
                                }.buttonStyle(PlainButtonStyle())
                            }
                            .padding(.vertical)
                        }
                        .padding(.top)

                        NavigationLink {
                            ShiftListView()
                        } label: {
                            Text("")
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()

                    // MARK: - Total Money Chart

                    homeSection(header: "Total Money") {
                        VStack {
                            NetMoneyGraph()
                                .padding()
                        }
                        .frame(height: 300)
                    }
                    .padding()

                    // MARK: - Current Payoff Item Section

                    VStack {
                        HStack {
                            Text("Payoff queue")
                                .font(.headline)
                            Spacer()
                            NavigationLink {
                                PayoffQueueView()
                            } label: {
                                Text("All")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(user.getQueue().indices, id: \.self) { index in
                                    if let expense = user.getItemWith(queueSlot: index) as? Expense {
                                        NavigationLink {
                                            ExpenseDetailView(expense: expense)
                                        } label: {
                                            PayoffWithImageAndGradientView(item: expense)
                                                .allPartsTappable()
                                                .rectContainer()
                                        }
                                        .buttonStyle(.plain)
                                    }

                                    if let goal = user.getItemWith(queueSlot: index) as? Goal {
                                        NavigationLink {
                                            PayoffItemDetailView(payoffItem: goal)
                                        } label: {
                                            PayoffWithImageAndGradientView(item: goal)
                                                .allPartsTappable()
                                                .rectContainer()
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .padding(.top)

                    // MARK: - My Wage Breakdown

                    WageBreakdownBox()
                        .padding()
                }
            }
        }
        .background(Color.targetGray)
        .navigationDestination(for: String.self, destination: { _ in
            StatsView()
        })
        .putInTemplate()
        .navigationTitle(Date.now.getFormattedDate(format: .abbreviatedMonth))
        .safeAreaInset(edge: .bottom) { QuickAddButton() }
    }
}

// MARK: - QuickAddButton

struct QuickAddButton: View {
    @EnvironmentObject private var vm: NewHomeViewModel
    @State private var didTapQuickAdd = false
    @ObservedObject private var settings = User.main.getSettings()
    var body: some View {
        ZStack {
            Button {
                vm.navManager.appendCorrectPath(newValue: .newItemCreation)
            } label: {
                VStack {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .background(Circle().fill(.white))
                        .foregroundStyle(settings.getDefaultGradient())
                        .rotationEffect(didTapQuickAdd ? .degrees(315) : .degrees(0))
                }
            }
        }
        .padding(.bottom, 5)
    }
}

// MARK: - PlusMenu

struct PlusMenu: View {
    let widthAndHeight: CGFloat

    var body: some View {
        HStack(spacing: 50) {
            NavigationLink {
                SpendNewMoneyFirstView()
            } label: {
                Image(systemName: "chart.line.downtrend.xyaxis.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color.niceRed.getGradient())
                    .background(Circle().fill(.white))
                    .frame(width: widthAndHeight, height: widthAndHeight)
            }
            NavigationLink {
                AddNewMoneyFirstView()
            } label: {
                Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color.okGreen.getGradient())
                    .background(Circle().fill(.white))
                    .frame(width: widthAndHeight, height: widthAndHeight)
            }
        }
        .transition(.scale)
    }
}

// MARK: - HomeView_Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .putInNavView(.inline)
            .environmentObject(NavManager())
    }
}
