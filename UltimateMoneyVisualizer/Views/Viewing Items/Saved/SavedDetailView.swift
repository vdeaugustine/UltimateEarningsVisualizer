//
//  SavedDetailView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI
import Vin

// MARK: - SavedDetailView

struct SavedDetailView: View {
    @State private var showDeleteConfirmation = false
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var user = User.main
    @ObservedObject private var settings = User.main.getSettings()
    @Environment(\.managedObjectContext) private var viewContext

    @State var saved: Saved

    var payoffItems: [PayoffItem] {
        saved.getPayoffItemsAllocatedTo()
    }

    var body: some View {
        VStack {
            List {
                if let info = saved.info {
                    Section("Description") {
                        Text(info)
                    }
                }

                Section {
                    HStack {
                        SystemImageWithFilledBackground(systemName: "chart.line.uptrend.xyaxis", backgroundColor: settings.themeColor)
                        Text("Total amount")
                            .spacedOut {
                                Text(saved.amount.formattedForMoney())
                            }
                    }
                }

                Section("Tags") {
                    VStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(saved.getTags()) { tag in
                                    NavigationLink {
                                        TagDetailView(tag: tag)

                                    } label: {
                                        Text(tag.title ?? "NA")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .padding(.trailing, 10)
                                            .background {
                                                PriceTag(height: 30, color: tag.getColor(), holePunchColor: .listBackgroundColor)
                                            }
                                    }
                                }
                            }
                        }

                        NavigationLink {
                            CreateTagView(saved: saved)
                        } label: {
                            Label("New Tag", systemImage: "plus")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                        .padding(.top)
                    }
                    .listRowBackground(Color.listBackgroundColor)
                }

                Section("Instances") {
                    ForEach(user.getInstancesOf(savedItem: saved)) { thisSaved in
                        NavigationLink {
                            SavedDetailView(saved: thisSaved)
                        } label: {
                            Text(thisSaved.getDate().getFormattedDate(format: .abreviatedMonth))
                                .spacedOut(text: thisSaved.getAmount().formattedForMoney())
                        }
                    }
//                    ForEach(user.getInstancesOf(savedItem: saved)) { savedItem in
//                        Text(savedItem.titleStr)
//                            .spacedOut(text: savedItem.getDate().getFormattedDate(format: .slashDate))
//                    }
                }

                Section("Allocations") {
                    ForEach(payoffItems.indices, id: \.self) { index in

                        if let goal = payoffItems.safeGet(at: index) as? Goal {
                            HStack {
                                SystemImageWithFilledBackground(systemName: "target", backgroundColor: settings.themeColor)

                                Text(goal.titleStr)
                                    .spacedOut(text: saved.amountAllocated(for: goal).formattedForMoney())
                            }
                        }

                        if let expense = payoffItems.safeGet(at: index) as? Expense {
                            HStack {
                                SystemImageWithFilledBackground(systemName: "creditcard.fill", backgroundColor: settings.themeColor)

                                Text(expense.titleStr)
                                    .spacedOut(text: saved.amountAllocated(for: expense).formattedForMoney())
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .padding(.bottom)
        .bottomButton(label: "Delete", action: {
            showDeleteConfirmation = true
        })
        .background(Color.targetGray)
        .putInTemplate()
        .navigationTitle(saved.getTitle())
        .confirmationDialog("Are you sure you want to delete this saved item?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
//                user.removeFromSavedItems(saved)
                viewContext.delete(saved)
                do {
                    try viewContext.save()
                } catch {
                    print("Error saving after delete", error)
                }

                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone")
        }
        .toolbar {
            ToolbarItem {
                NavigationLink("Edit") {
                    EditSavedItemView(saved: $saved)
                }
            }
        }
    }
}

// MARK: - SavedDetailView_Previews

struct SavedDetailView_Previews: PreviewProvider {
    static let context = PersistenceController.context

    static let saved: Saved = {
        let saved = Saved(context: context)

        saved.title = "Test saved"
        saved.amount = 1_000
        saved.info = "this is a test description"
        saved.date = Date()

        return saved
    }()

    static var previews: some View {
        SavedDetailView(saved: User.main.getSaved().first!)
            .putInNavView(.inline)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
