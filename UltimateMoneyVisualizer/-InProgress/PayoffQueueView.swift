//
//  PayoffQueueView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/1/23.
//

import SwiftUI

// MARK: - PayoffQueueView

struct PayoffQueueView: View {
    @ObservedObject private var user: User = User.main
    @ObservedObject private var settings: Settings = User.main.getSettings()

    @State private var newPayoffQueue: [PayoffItem] = User.main.getQueue()
//    @State private var editMode: EditMode = .inactive

    
    @State private var someArr: [Int] = (0 ... 10).map { $0 }

    var body: some View {
        List {
            ForEach(user.getQueue().indices, id: \.self) { index in

                if let expense = user.getItemWith(queueSlot: index + 1) as? Expense {
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
                    }
                    .buttonStyle(.plain)
                }

                if let goal = user.getItemWith(queueSlot: index + 1) as? Goal {
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
                                    Image("disneyworld")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        //                            .clipShape(Circle())
                                        //                            .height(90)
                                        .frame(width: 150)
                                        .cornerRadius(8)

                                    if let dueDate = goal.dueDate {
                                        Text(dueDate.getFormattedDate(format: .abreviatedMonth))
                                            .font(.caption).foregroundColor(Color.hexStringToColor(hex: "8E8E93"))
                                    }
                                }
                                .padding()
                            }
                        }
                        .allPartsTappable()
                    }
                    .buttonStyle(.plain)
                }
            }
            .onMove(perform: move)
//            .moveDisabled(editMode != .active)
        }
        .listStyle(.plain)
        .navigationTitle("Payoff Queue")
        .putInTemplate()
        .toolbar {
            ToolbarItem {
                EditButton()
            }
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        let preMove = user.getQueue()
        var afterMove = preMove
        afterMove.move(fromOffsets: source, toOffset: destination)

        var counter = 1

        for item in afterMove {
            var payoff = item
            payoff.queueSlotNumber = Int16(counter)
            counter += 1
        }

        let expenses = afterMove.compactMap { $0 as? Expense }
        let goals = afterMove.compactMap { $0 as? Goal }

        user.goals = NSSet(array: goals)
        user.expenses = NSSet(array: expenses)

        try! user.managedObjectContext!.save()
//        newPayoffQueue.move(fromOffsets: source, toOffset: destination)
//
//
//        print("----- after move -----")
//        for item in newPayoffQueue {
//            print(item.titleStr, item.queueSlotNumber)
//        }
//
//        print("---- doing change ----")
//        for index in newPayoffQueue.indices {
//            newPayoffQueue[index].queueSlotNumber = Int16(index + 1)
//            print(newPayoffQueue[index].titleStr,
//                  "Now has index",
//                  newPayoffQueue[index].queueSlotNumber)
//        }
//
//        let goals = newPayoffQueue.compactMap { $0 as? Goal }
//        let expenses = newPayoffQueue.compactMap { $0 as? Expense }
//
//        user.goals = NSSet(array: goals)
//        user.expenses = NSSet(array: expenses)
//
//        try! user.managedObjectContext!.save()
//
//        print("After save")
//
//        print("-------- Local -------")
//        let unsorted: [PayoffItem] = goals + expenses
//        let sorted = unsorted.sorted { $0.queueSlotNumber < $1.queueSlotNumber }
//
//        for sort in sorted {
//            print(sort.titleStr, sort.queueSlotNumber)
//        }
//
//        print("-------- Fetching -------")
//
//        let queue = user.getQueue()
//        for queueItem in queue {
//            print(queueItem.titleStr, queueItem.queueSlotNumber)
//        }
    }
}

// MARK: - PayoffQueueView_Previews

struct PayoffQueueView_Previews: PreviewProvider {
    static var previews: some View {
        PayoffQueueView()
            .putInNavView(.inline)
    }
}
