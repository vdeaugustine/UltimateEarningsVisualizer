//
//  NewExpenseList.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/16/23.
//

import SwiftUI

// MARK: - NewPayoffList

struct NewPayoffList: View {
    let payoffType: PayoffType

    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var user = User.main

    // swiftformat:sort:begin
    @State private var filtersApplied: [ShowTypeChoice] = ShowTypeChoice.allCases
    @State private var searchText: String = ""
    @State private var showDeleteError = false
    @State private var showSearch: Bool = false
    // swiftformat:sort:end

    private var sortedItems: [PayoffItem] {
        var items: [PayoffItem] = payoffType == .expense ? user.getExpenses() : user.getGoals()
        if searchText.isEmpty == false {
            items = items.filter { item in
                item.titleStr.removingWhiteSpaces().lowercased().contains(searchText.removingWhiteSpaces().lowercased())
            }
        }
        return items
            .sorted(by: { ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture) })
    }

    // CATEGORY: Internal

    enum ShowTypeChoice: String, CaseIterable, Identifiable {
        case paidOff = "Paid Off"
        case notPaidOff = "Not Paid Off"
        case dueDate = "Has Due Date"

        // CATEGORY: Internal

        var id: Self { self }
    }

    var body: some View {
        VStack {
            if sortedItems.isEmpty == false {
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
                        .onDelete(perform: deleteSavedItem)

                        .listRowSeparator(.hidden)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            else {
                Color.listBackgroundColor
            }
        }
        .background { Color.clear }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSearch.toggle()
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    switch payoffType {
                        case .goal:
                            NavManager.shared.appendCorrectPath(newValue: .createGoal)
                        case .expense:
                            NavManager.shared.appendCorrectPath(newValue: .createExpense)
                        case .tax:
                            return
                    }
                } label: {
                    Label("Add New \(payoffType.rawValue.capitalized)", systemImage: "plus")
                }
            }

            if sortedItems.isEmpty == false {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
        .conditionallySearchable(isSearching: showSearch, searchText: $searchText)
        .listStyle(.plain)
        .navigationTitle(payoffType.rawValue.capitalized + "s")
        .putInTemplate()
        .alert("Error deleting", isPresented: $showDeleteError, actions: {}) {
            Text("Please try again or restart the app.")
        }
    }

    func deleteSavedItem(at offsets: IndexSet) {
        for offset in offsets {
            guard let itemToDelete = sortedItems.safeGet(at: offset)
            else { continue }
            if let goal = itemToDelete as? Goal {
                viewContext.delete(goal)
            }
            if let expense = itemToDelete as? Expense {
                viewContext.delete(expense)
            }
            do {
                try viewContext.save()
            } catch {
                showDeleteError = true
            }
        }
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

// MARK: - NewPayoffList_Previews

struct NewPayoffList_Previews: PreviewProvider {
    static var previews: some View {
        NewPayoffList(payoffType: .goal)
            .putInNavView(.large)
            .templateForPreview()
    }
}
