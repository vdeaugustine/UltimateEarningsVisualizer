//
//  EditTimeBlockView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/17/23.
//

import SwiftUI

// MARK: - EditTimeBlockView

struct EditTimeBlockView: View {
    let block: TimeBlock

    @Binding var isPresented: Bool

    @State private var endTime: Date = .now
    @State private var startTime: Date = .now
    @State private var title: String = ""
    @State private var color: Color

    @Environment(\.dismiss) private var dismiss

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
            dismiss()
        } catch {
            // Handle save error, maybe show an alert
            // TODO: Handle errors
        }
    }
}

// MARK: - EditTimeBlockView_Previews

struct EditTimeBlockView_Previews: PreviewProvider {
    static let user: User = {
        let user = User(context: PersistenceController.testing)
        user.instantiateExampleItems(context: PersistenceController.testing)
        let timeBlock = try! TimeBlock(title: "This is a test time block",
                                       start: .now.addHours(-1),
                                       end: .now.addHours(0.4),
                                       colorHex: Color.yellow.hex,
                                       user: user,
                                       context: PersistenceController.testing)
        return user
    }()

    static var previews: some View {
        EditTimeBlockView(block: user.timeBlocks!.allObjects.first! as! TimeBlock, isPresented: .constant(true))
    }
}
