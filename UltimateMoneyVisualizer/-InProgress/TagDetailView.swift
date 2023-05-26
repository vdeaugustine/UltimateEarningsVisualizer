//
//  TagDetailView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/25/23.
//

import SwiftUI

// MARK: - TagDetailView

struct TagDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var user = User.main
    @Environment(\.dismiss) private var dismiss

    let tag: Tag

    let symbolWidthHeight: CGFloat = 40

    var body: some View {
        Form {
            Section("Tag Title") {
                Text(tag.getTitle())
            }

            Section("Symbol") {
                HStack {
                    SystemImageWithFilledBackground(systemName: tag.getSymbolStr(), backgroundColor: user.getSettings().themeColor, width: symbolWidthHeight, height: symbolWidthHeight)

                    Spacer()

                    Button("Edit") {
                    }
                }
            }

            Section("Goals") {
                ForEach(user.getGoalsWith(tag: tag)) { goal in

                    NavigationLink {
                        GoalDetailView(goal: goal)
                    } label: {
                        Text(goal.titleStr)
                    }
                }
            }

            Section("Expenses") {
                ForEach(user.getExpensesWith(tag: tag)) { expense in

                    NavigationLink {
                        ExpenseDetailView(expense: expense)
                    } label: {
                        Text(expense.titleStr)
                    }
                }
            }

            Section("Saved Items") {
                ForEach(user.getSavedItemsWith(tag: tag)) { saved in

                    NavigationLink {
                        SavedDetailView(saved: saved)
                        
                        
                    } label: {
                        Text(saved.getTitle())
                    }
                }
            }
        }
        .putInTemplate()
        .navigationTitle("Tag Details")
    }
}

// MARK: - TagDetailView_Previews

struct TagDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TagDetailView(tag: User.main.getTags().first!)
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
