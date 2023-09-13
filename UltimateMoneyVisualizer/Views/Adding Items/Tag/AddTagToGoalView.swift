//
//  AddTagToExpenseView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/22/23.
//

import AlertToast
import SwiftUI
import Vin

// MARK: - AddTagToGoalView

struct AddTagToGoalView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let goal: Goal
    @ObservedObject private var user = User.main
    @State private var selectedTags = [Tag]()

    @State private var showFailedSaveAlert = false
    @State private var showSuccessAlert = false

    var body: some View {
        List {
            Section("Goal") {
                Text(goal.titleStr)
                if let info = goal.info {
                    Text(info)
                }
            }

            Section("Current tags") {
                if selectedTags.isEmpty {
                    Text("None")
                } else {
                    ForEach(selectedTags) { tag in
                        Text(tag.getTitle())
                    }
                    .onDelete { indexSet in
                        selectedTags.remove(atOffsets: indexSet)
                    }
                }
            }

            Section("Previously Used Tags") {
                Button {
                    NavManager.shared.appendCorrectPath(newValue: .createTag(AnyPayoffItem(goal)))

                } label: {
                    Label("Create New", systemImage: "plus")
                }

                if let tags = user.tags?.allObjects as? [Tag] {
                    ForEach(tags) { tag in
                        Text(tag.getTitle())
                            .allPartsTappable(alignment: .leading)
                            .onTapGesture {
                                if selectedTags.contains(tag) == false {
                                    selectedTags.append(tag)
                                }
                            }
                    }
                } else {
                    Text("No tags yet")
                }
            }
        }
        .navigationTitle("Tags")
        .putInTemplate()
        .bottomButton(label: "Save") {
            for tag in selectedTags {
                tag.addToGoals(goal)
                goal.addToTags(tag)
            }
            do {
                try viewContext.save()
                showSuccessAlert.toggle()
            } catch {
                showFailedSaveAlert.toggle()
            }
        }
        .alert("Error saving", isPresented: $showFailedSaveAlert) {} message: {
            Text("Try again or restart app")
        }
        .toast(isPresenting: $showSuccessAlert) {
            .successWith(message: "Saved Tags")
        }
    }
}

// MARK: - AddTagToGoalView_Previews

struct AddTagToGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddTagToGoalView(goal: User.main.getGoals().first!)
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
