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
    @Environment(\.managedObjectContext) private var viewContext
    let block: TimeBlock
    @State private var showDetailConfirmation = false

    @State private var showDeleteError = false
    @Environment (\.dismiss) private var dismiss

    var body: some View {
        List {
            if let startDate = block.startTime {
                Text("Date")
                    .spacedOut(text: startDate.getFormattedDate(format: .abreviatedMonth))
                Text("Start")
                    .spacedOut(text: startDate.getFormattedDate(format: .minimalTime))
            }

            if let endDate = block.endTime {
                Text("End")
                    .spacedOut(text: endDate.getFormattedDate(format: .minimalTime))
            }

            Section("Stats") {
                Text("Duration")
                    .spacedOut(text: block.duration.formatForTime())

                Text("Earned")
                    .spacedOut(text: block.amountEarned().formattedForMoney())
            }
        }
        .navigationTitle("Time Block Details")
        .putInTemplate()
        .bottomButton(label: "Delete") {
            showDetailConfirmation.toggle()
        }
        .confirmationDialog("Delete Time Block?",
                            isPresented: $showDetailConfirmation,
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

//        .toolbar {
//            ToolbarItem {
//                Button {
//
//                } label: {
//                    Text("Delete")
//                }
//            }
//        }
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
