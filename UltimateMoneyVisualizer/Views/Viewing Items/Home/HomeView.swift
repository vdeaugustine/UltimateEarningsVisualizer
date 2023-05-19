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
    @ObservedObject private var settings = User.main.getSettings()
    @ObservedObject private var user = User.main

    @State private var currentPayoffQueueSlot: Int = 1

    var body: some View {
        VStack {
//            #if DEBUG
            Text("Deletes and recreates data every time " + (PersistenceController.inMemory ? "TRUE" : "FALSE"))
//            #endif
            ZStack {
                ScrollView {
                    // MARK: - Lifetime Money

                    VStack {
                        homeSection(rectContainer: false) {
                            HStack {
                                Text("Lifetime")
                                    .font(.headline)
                                Spacer()
                                NavigationLink {
                                    StatsView()
                                } label: {
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
                                        Text(user.totalEarned().formattedForMoney())
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

                                            VStack(spacing: 15) {
                                                HStack {
                                                    Text(expense.titleStr)
                                                        .font(.headline)
                                                        .pushLeft()

                                                    if expense.dueDate != nil {
                                                        Text("due in " + expense.timeRemaining.formatForTime([.year, .hour, .minute, .second]))
                                                            .font(.subheadline)
                                                    }
                                                }

                                                VStack(alignment: .leading, spacing: 5) {
                                                    ProgressBar(percentage: expense.percentPaidOff, color: settings.themeColor)
                                                    Text(expense.amountPaidOff.formattedForMoney())
                                                        .font(.subheadline)
                                                        .spacedOut {
                                                            Text(expense.amountRemainingToPayOff.formattedForMoney())
                                                                .font(.subheadline)
                                                        }
                                                }
                                            }

                                            .padding()
                                            .allPartsTappable()
                                            .rectContainer()
                                        }
                                        .buttonStyle(.plain)
                                    }

                                    if let goal = user.getItemWith(queueSlot: index) as? Goal {
                                        NavigationLink {
                                            GoalDetailView(goal: goal)
                                        } label: {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text(goal.titleStr)
                                                        .font(.headline)
                                                        .foregroundStyle(settings.getDefaultGradient())
                                                        .pushLeft()

                                                    HStack(alignment: .bottom, spacing: 5) {
                                                        Text(goal.amountMoneyStr)
                                                        Spacer()
                                                        Text("GOAL")
                                                            .font(.system(size: 10, weight: .bold, design: .rounded))
                                                            .foregroundColor(.gray)
                                                    }
                                                    .padding(.top, 4)

                                                    VStack {
                                                        VStack(spacing: 1) {
                                                            Text("Paid off")
                                                                .font(.caption2)
                                                                .spacedOut {
                                                                    Text(goal.amountPaidOff.formattedForMoney())
                                                                        .font(.caption2)
                                                                }
                                                            ProgressBar(percentage: goal.percentPaidOff, color: settings.themeColor)
                                                        }

                                                        VStack(spacing: 1) {
                                                            Text("Remaining")
                                                                .font(.caption2)
                                                                .spacedOut {
                                                                    Text(goal.timeRemaining.formatForTime([.year, .day, .hour, .minute]))
                                                                        .font(.caption2)
                                                                }
                                                        }
                                                    }
                                                    .padding(.top)
                                                    .pushTop(alignment: .leading)
                                                }
                                                .frame(maxWidth: .infinity)
                                                .padding()

                                                HStack {
                                                    VStack {
                                                        if let image = goal.loadImageIfPresent() {
                                                            Image(uiImage: image)
                                                                .resizable()

                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(height: 75)
                                                                .frame(width: 125)

                                                                .cornerRadius(8)
                                                            
                                                            if let dueDate = goal.dueDate {
                                                                Text(dueDate.getFormattedDate(format: .abreviatedMonth))
                                                                    .font(.caption).foregroundColor(Color.hexStringToColor(hex: "8E8E93"))
                                                            }
                                                        }

                                                        
                                                    }
    //                                                .padding()
                                                }
                                            }
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

        .putInTemplate()
        .navigationTitle(Date.now.getFormattedDate(format: .abreviatedMonth))
        .safeAreaInset(edge: .bottom) {
            QuickAddButton()
        }
    }

    struct QuickAddButton: View {
        @State private var didTapQuickAdd = false
        @ObservedObject private var settings = User.main.getSettings()
        var body: some View {
            ZStack {
                if didTapQuickAdd {
                    PlusMenu(widthAndHeight: 50)
                        .offset(y: -60)
                }

                Button {
                    withAnimation(.easeInOut(duration: 0.7)) {
                        didTapQuickAdd.toggle()
                    }

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
}

// MARK: - HomeView_Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .putInNavView(.inline)
        }
    }
}
