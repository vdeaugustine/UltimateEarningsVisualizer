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
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showDeleteConfirmation = false
    @State private var showDeleteError = false

    let block: TimeBlock

    var body: some View {
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

//            Section {
//                Button("Delete", role: .destructive) {
//                    showDeleteConfirmation.toggle()
//                }
//            }
        }
        .navigationTitle("Time Block Details")
        .putInTemplate()

        .confirmationDialog("Delete Time Block?",
                            isPresented: $showDeleteConfirmation,
                            titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                viewContext.delete(block)

                do {
                    try viewContext.save()
                    dismiss()
                } catch {
                    showDeleteError.toggle()
                }
            }
        }
        .toast(isPresenting: $showDeleteError) {
            .errorWith(message: "Error saving")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showDeleteConfirmation.toggle()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}

// MARK: - TimeBlockDetailView_Previews

struct TimeBlockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TimeBlockDetailView(block: User.main.getTimeBlocksBetween().first!)
            .putInNavView(.inline)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
