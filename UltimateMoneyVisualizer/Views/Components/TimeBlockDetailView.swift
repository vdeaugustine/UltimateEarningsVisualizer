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


// MARK: - EditTimeBlockView

struct EditTimeBlockView: View {
    let block: TimeBlock

    @Binding var isPresented: Bool

    @State private var endTime: Date = .now
    @State private var startTime: Date = .now
    @State private var title: String = ""
    @State private var color: Color

    init(block: TimeBlock, isPresented: Binding<Bool>) {
        self.block = block
        self._isPresented = isPresented
        self._endTime = State(initialValue: block.endTime ?? .now)
        self._startTime = State(initialValue: block.startTime ?? .now)
        self._title = State(initialValue: block.getTitle())
        self._color = State(initialValue: block.getColor())
    }
    
    @FocusState private var editTitleFieldFocused

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            Form {
                Section("Title") {
                    TextField("Title", text: $title)
                        .focused($editTitleFieldFocused)
                }

                Section("Times") {
                    DatePicker("Start time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End time", selection: $endTime, displayedComponents: .hourAndMinute)
                }

                Section("Color") {
                    ColorPicker("Block Color", selection: $color)
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

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .foregroundStyle(.white)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false 
                    }
                    .foregroundStyle(.white)
                }
            }
            .onTapGesture {
                if editTitleFieldFocused {
                    editTitleFieldFocused = false
                }
            }
            .putInTemplate(title: "Edit Time Block", displayMode: .large)
        }
        
    }

    func saveChanges() {
        block.startTime = startTime
        block.endTime = endTime
        block.title = title

        do {
            try viewContext.save()
        } catch {
            // Handle save error, maybe show an alert
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
