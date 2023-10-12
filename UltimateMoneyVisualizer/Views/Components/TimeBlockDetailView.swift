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
    // swiftformat:sort:begin
    let block: TimeBlock

    @Environment(\.dismiss) private var dismiss
    @Environment(\.editMode) private var editMode

    @State private var endTime: Date = .now

    @State private var showDeleteConfirmation = false
    @State private var showDeleteError = false
    @State private var showErrorAlert = false

    @State private var showSavedAlert = false

    @State private var startTime: Date = .now
    @State private var title: String = ""
    
    @FocusState private var editTitleFieldFocused

    @Environment(\.managedObjectContext) private var viewContext
    // swiftformat:sort:end

    var body: some View {
        VStack {
            if let editMode,
               editMode.wrappedValue.isEditing {
                editingView
            } else {
                viewingMode
            }
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
                EditButton()
                    .foregroundStyle(.white)
            }
        }
        .onChange(of: editMode?.wrappedValue.isEditing, perform: { newValue in
            if newValue == false {
                block.startTime = startTime
                block.endTime = endTime
                block.title = title

                do {
                    try viewContext.save()
                    showSavedAlert = true
                } catch {
                    showErrorAlert = true
                }
            }
        })
        .alert("Error saving changes", isPresented: $showErrorAlert) {} message: {
            Text("Please try again. If issue persists, try restarting the app.")
        }
        .alert("Successfully saved changes", isPresented: $showSavedAlert) {}
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
                    showDeleteConfirmation.toggle()
                } label: {
                    Label("Delete", systemImage: "trash")
                        .foregroundStyle(.red)
                }
            }
        }
    }

    private var editingView: some View {
        Form {
            Section("Title") {
                TextField("Title", text: $title)
                    .focused($editTitleFieldFocused)
            }

            Section("Times") {
                DatePicker("Start time", selection: $startTime, displayedComponents: .hourAndMinute)
                DatePicker("End time", selection: $endTime, displayedComponents: .hourAndMinute)
            }
        }
        .onAppear {
            startTime = block.startTime ?? .now
            endTime = block.endTime ?? .now
            title = block.getTitle()
            editTitleFieldFocused = true
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    editTitleFieldFocused = false
                }
            }
        }
        .onTapGesture {
            if editTitleFieldFocused {
                editTitleFieldFocused = false 
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
