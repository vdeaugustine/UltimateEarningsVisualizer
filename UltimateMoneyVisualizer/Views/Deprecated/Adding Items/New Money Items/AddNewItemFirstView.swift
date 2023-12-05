//
//  AddNewItemFirstView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/4/23.
//

import SwiftUI

// MARK: - NewItemSelection

enum NewItemSelection: String {
    case made, spent, shift, saved, goal, expense, none
}

// MARK: - AddNewMoneyFirstView
// Deprecated
struct AddNewMoneyFirstView: View {
    enum MoneyType { case spent, made }

    let subTitles: [NewItemSelection: String] = [.made: "Add to your money.",
                                                 .spent: "Allocate your money towards an expense or goal.",
                                                 .saved: "You could have spent money but instead you chose a cheaper alternative.",
                                                 .expense: "An item you have already spent money on",
                                                 .goal: "An item you want to save up for.",
                                                 .shift: "Enter your hours you worked and money will be automatically generated for you using your wage settings."]

    var body: some View {
        VStack {
            VStack(spacing: 65) {
                homeSection(rectContainer: false, header: "Made Money") {
                    HStack {
                        NavigationLink {
                            NewShiftView()
                        } label: {
                            button(header: .shift)
                        }
                        NavigationLink {
                            CreateSavedView()
                        } label: {
                            button(header: .saved)
                        }
                    }
                    .padding(.top, 7)
                }
                .frame(height: 200)
            }

            .padding()
            .padding(.top)

            Spacer()
        }
        .putInTemplate()
        .navigationTitle("Add Item")
    }

    func button(header: NewItemSelection) -> some View {
//        ZStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 10) {
            Text(header.rawValue.capitalized)
                .font(.title3)
                .fontWeight(.medium)
            Text(subTitles[header] ?? "")
                .font(.caption)
                .fontWeight(.light)
                .padding(.leading)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .padding(.top, 10)

        .cornerRadius(8)

        .rectContainer(shadowRadius: 1)
    }
}

// MARK: - AddNewMoneyFirstView_Previews

struct AddNewMoneyFirstView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewMoneyFirstView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}

// MARK: - SpendNewMoneyFirstView

struct SpendNewMoneyFirstView: View {
    enum MoneyType { case spent, made }

    let subTitles: [NewItemSelection: String] = [.made: "Add to your money.",
                                                 .spent: "Allocate your money towards an expense or goal.",
                                                 .saved: "You could have spent money but instead you chose a cheaper alternative.",
                                                 .expense: "An item you have already spent money on",
                                                 .goal: "An item you want to save up for.",
                                                 .shift: "Enter your hours you worked and money will be automatically generated for you using your wage settings."]

    var body: some View {
        VStack {
            VStack(spacing: 65) {
                homeSection(rectContainer: false, header: "Spent Money") {
                    HStack {
                        NavigationLink {
                            CreateExpenseView()
                        } label: {
                            button(header: .expense)
                        }
                        NavigationLink {
                            CreateGoalView()
                        } label: {
                            button(header: .goal)
                        }
                    }
                    .padding(.top, 7)
                }
                .frame(height: 200)
            }

            .padding()
            .padding(.top)

            Spacer()
        }
        .putInTemplate()
        .navigationTitle("Add Item")
    }

    func button(header: NewItemSelection) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(header.rawValue.capitalized)
                .font(.title3)
                .fontWeight(.medium)
            Text(subTitles[header] ?? "")
                .font(.caption)
                .fontWeight(.light)
                .padding(.leading)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .padding(.top, 10)

        .cornerRadius(8)

        
        .rectContainer(shadowRadius: 1)
    }
}

// MARK: - SpendNewMoneyFirstView_Previews

struct SpendNewMoneyFirstView_Previews: PreviewProvider {
    static var previews: some View {
        SpendNewMoneyFirstView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
