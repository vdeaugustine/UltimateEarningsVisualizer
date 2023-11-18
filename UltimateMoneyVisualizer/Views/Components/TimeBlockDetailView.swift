//
//  EditTimeBlockView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/8/23.
//

import AlertToast
import SwiftUI

// MARK: - TimeBlockDetailView

struct TimeBlockDetailView: View {
    let block: TimeBlock

    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showDeleteConfirmation = false
    @State private var showDeleteError = false
    @State private var showErrorAlert = false
    @State private var isEditSheetPresented = false

    var body: some View {
        VStack {
            viewingMode
        }
        .navigationTitle("Time Block Details")
        .putInTemplate()
        .confirmationDialog("Delete Time Block?",
                            isPresented: $showDeleteConfirmation,
                            titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                deleteBlock()
            }
        }
        .toast(isPresenting: $showDeleteError) {
            .errorWith(message: "Error saving")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isEditSheetPresented.toggle()
                }) {
                    Text("Edit")
                }
                .foregroundStyle(.white)
            }
        }
        .sheet(isPresented: $isEditSheetPresented) {
            EditTimeBlockView(block: block, isPresented: $isEditSheetPresented)
        }
        .alert("Error saving changes", isPresented: $showErrorAlert) {} message: {
            Text("Please try again. If issue persists, try restarting the app.")
        }
    }

    private var viewingMode: some View {
        List {
            if let title = block.title {
                Section("Title") {
                    Text(title)
                }
            }

            if let startDate = block.startTime {
                Section("Date") {
                    Text(startDate.getFormattedDate(format: .abbreviatedMonth))
                }
                Section("Start time") {
                    Text(startDate.getFormattedDate(format: .minimalTime))
                }
            }

            if let endDate = block.endTime {
                Section("End time") {
                    Text(endDate.getFormattedDate(format: .minimalTime))
                }
            }

            Section("Stats") {
                Text("Duration")
                    .spacedOut(text: block.duration.formatForTime())

                Text("Earned")
                    .spacedOut(text: block.amountEarned().money())
            }

            Section {
                Button {
                    
                } label: {
                    Label("What are time blocks?", systemImage: "questionmark.circle")
                }
            }

            Section {
                Button {
                    showDeleteConfirmation.toggle()
                } label: {
                    Label("Delete", systemImage: "trash")
                        .foregroundStyle(.red)
                }
            }


        }
    }

    private func deleteBlock() {
        viewContext.delete(block)

        do {
            try viewContext.save()
            dismiss()
        } catch {
            showDeleteError.toggle()
        }
    }
}




// MARK: - TimeBlockDetailView_Previews

struct TimeBlockDetailView_Previews: PreviewProvider {
    static let block: TimeBlock = {
        let user = User.testing

        return try! TimeBlock(title: "Testing this time block", start: .now.addHours(-2), end: .now.addHours(3), colorHex: Color.green.getHex(), user: user, context: user.managedObjectContext!)

    }()

    static var previews: some View {
        TimeBlockDetailView(block: block)
            .putInNavView(.inline)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
