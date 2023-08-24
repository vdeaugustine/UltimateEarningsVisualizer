//
//  NewExpenseList.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/16/23.
//

import SwiftUI

struct NewPayoffList: View {
    let payoffType: PayoffType
    @State private var searchText: String = ""
    @State private var showSearch: Bool = false
    // CATEGORY: Internal

    enum ShowTypeChoice: String, CaseIterable, Identifiable {
        case paidOff = "Paid Off"
        case notPaidOff = "Not Paid Off"
        case dueDate = "Has Due Date"

        // CATEGORY: Internal

        var id: Self { self }
    }

    var body: some View {
        List{
            Section {
                ForEach(sortedItems.indices, id: \.self) { index in
                    if let item = sortedItems.safeGet(at: index) {
                        Button {
                            if let goal = item as? Goal {
                                print("tapped goal")
                                NavManager.shared.appendCorrectPath(newValue: .goal(goal))
                            } else if let expense = item as? Expense {
                                print("tapped expense")
                                NavManager.shared.appendCorrectPath(newValue: .expense(expense))
                            }
                        } label: {
                            PayoffItemRectGeneral(item: item)
                                .allPartsTappable()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .listRowSeparator(.hidden)
            } header: {
                Text("Items").hidden()
            }
            .listRowBackground(Color.clear)
        }

        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSearch.toggle()
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    CreateSavedView()
                } label: {
                    Label("Add Saved Item", systemImage: "plus")
                }
            }
        }
        .conditionalModifier(showSearch) { view in
            view
                .searchable(text: $searchText)
        }
        .background { Color.clear }
        .listStyle(.plain)
        .navigationTitle(payoffType == .goal ? "Goals" : "Expenses")
        .putInTemplate()
    }

    @ViewBuilder func background(for filter: ShowTypeChoice) -> some View {
        if filtersApplied.contains(filter) {
            Color.googleBlueLabelBackground
                .clipShape(Capsule(style: .continuous))
        } else {
            Color.textSecondary
                .clipShape(Capsule(style: .continuous).stroke(lineWidth: 1))
        }
    }

    func backgroundColor(for filter: ShowTypeChoice) -> Color {
        filtersApplied.contains(filter) ? Color.googleBlueLabelBackground : Color.clear
    }

    func textColor(for filter: ShowTypeChoice) -> Color {
        filtersApplied.contains(filter) ? Color.googleBlueLabelText : Color.textSecondary
    }

    // CATEGORY: Private

    @ObservedObject private var user = User.main

    @State private var filtersApplied: [ShowTypeChoice] = ShowTypeChoice.allCases

    private var sortedItems: [PayoffItem] {
        let items: [PayoffItem] = payoffType == .expense ? user.getExpenses() : user.getGoals()
        return items
            .sorted(by: { ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture) })
    }

    private var filterBar: some View {
        HStack {
            ForEach(ShowTypeChoice.allCases) { type in
                Button {
                    filtersApplied.insertOrRemove(element: type)
                } label: {
                    Text(type.rawValue)
                        .font(.caption2)
                        .foregroundStyle(textColor(for: type))
                        .padding(10)
                        .background { background(for: type) }
                }
            }
        }

        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical)

        .background { Color.white }
    }
}

struct NewPayoffList_Previews: PreviewProvider {
    static var previews: some View {
        NewPayoffList(payoffType: .goal)
            .templateForPreview()
    }
}
