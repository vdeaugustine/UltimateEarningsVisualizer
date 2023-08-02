//
//  StatsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/4/23.
//

import Charts
import SwiftUI
import Vin

// MARK: - StatsView

struct StatsView: View {
    @StateObject private var vm: StatsViewModel = .shared

    var body: some View {
        ScrollView {
            Picker("Section", selection: $vm.selectedSection) {
                ForEach(StatsViewModel.MoneySection.allCases) { section in
                    Text(section.rawValue.capitalized).tag(section)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            HorizontalDataDisplay(data: vm.dataItems)

            HStack {
                DatePicker("", selection: $vm.firstDate, in: .init(uncheckedBounds: (lower: Date.distantPast, upper: vm.secondDate)), displayedComponents: .date).labelsHidden()
                Text("-")
                DatePicker("", selection: $vm.secondDate, in: .init(uncheckedBounds: (lower: vm.firstDate, upper: .distantFuture)), displayedComponents: .date).labelsHidden()
            }
            .padding(.vertical, 10)

            // MARK: - Selected Section

            selectedSection
        }
        .background(Color.targetGray)
        .putInTemplate(displayMode: .large)
        .navigationTitle("My Stats")
        .navigationDestination(for: Shift.self) { ShiftDetailView(shift: $0) }
        .navigationDestination(for: Goal.self) { GoalDetailView(goal: $0) }
        .navigationDestination(for: Expense.self) { ExpenseDetailView(expense: $0) }
        .navigationDestination(for: Saved.self) { SavedDetailView(saved: $0) }
    }

    var selectedSection: some View {
        VStack {
            VStack(spacing: 0) {
                LineChart()
                    .frame(height: 300)

                Text(vm.chartFooter(for: vm.selectedSection))
                    .font(.footnote)
                    .padding(.horizontal)
                    .foregroundColor(.gray)
            }
            .padding([.horizontal, .bottom])

            List {
                Section {
                    ForEach(vm.itemsForList.indices, id: \.self) { itemIndex in
                        HStack {
                            HStack(spacing: 15) {
                                Image(systemName: vm.rowIcon(forIndex: itemIndex).imageName)
                                    .foregroundStyle(vm.rowIcon(forIndex: itemIndex).color)
                                Text(vm.rowText(forIndex: itemIndex).title)
                            }
                            Spacer()
                            Text(vm.rowText(forIndex: itemIndex).detail)
                        }
                        .allPartsTappable()
                        .onTapGesture { vm.tapAction(index: itemIndex) }
//                        .navigationDestination(for: Shift.self) { ShiftDetailView(shift: $0) }
//                        .navigationDestination(for: Goal.self) { GoalDetailView(goal: $0) }
//                        .navigationDestination(for: Expense.self) { ExpenseDetailView(expense: $0) }
//                        .navigationDestination(for: Saved.self) { SavedDetailView(saved: $0) }
                    }
                } header: {
                    Text(vm.listHeader.capitalized)
                        .format(size: 16, weight: .semibold)
                }
            }
            .scrollContentBackground(.hidden)
            .frame(height: CGFloat(vm.itemsForList.count * 60) + 30)
        }
    }

    struct LineChart: View {
        @ObservedObject private var user = User.main
        var title: String? = nil
        var backgroundColor: Color? = nil

        var body: some View {
            ZStack {
                if let backgroundColor = backgroundColor {
                    backgroundColor
                }
                VStack {
                    if let title = title {
                        Text(title.uppercased())
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }

                    VStack {
                        StatsViewChart()
                    }
                    .rectContainer(shadowRadius: 0.02)

                    .padding(.horizontal, 5)
                }
                .padding(.vertical)
            }
        }
    }
}

// MARK: - StatsView_Previews

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .putInNavView(.inline)
    }
}
