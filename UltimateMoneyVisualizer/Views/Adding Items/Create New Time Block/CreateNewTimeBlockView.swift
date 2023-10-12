//
//  CreateNewTimeBlockView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/3/23.
//

import CoreData
import SwiftUI

// MARK: - CreateNewTimeBlockView

struct CreateNewTimeBlockView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CreateNewTimeBlockViewModel
    @FocusState private var titleFocused: Bool

    init(_ starter: TimeBlockStarter_Shift) {
        _viewModel = StateObject(
            wrappedValue: CreateNewTimeBlockForShiftViewModel(shift: starter.shift,
                                                              start: starter.start,
                                                              end: starter.end)
        )
    }

    init(_ starter: TimeBlockStarter_Today) {
        _viewModel = StateObject(
            wrappedValue: TodayViewNewTimeBlockCreationModel(todayShift: starter.todayShift,
                                                             start: starter.start,
                                                             end: starter.end)
        )
    }

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $viewModel.title)
                    .focused($titleFocused)
               
                VStack {
                    Button {
                        withAnimation {
                            viewModel.showColorOptions.toggle()
                        }
                    } label: {
                        Text("Color")
                            .foregroundColor(.black)
                            .spacedOut {
                                HStack {
                                    Circle()
                                        .fill(Color.hexStringToColor(hex: viewModel.selectedColorHex))
                                        .frame(height: 20)
                                        .overlay(content: {
                                            Circle()
                                                .stroke(lineWidth: 1)
                                                .foregroundColor(.gray)
                                        })

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.hexStringToColor(hex: "BFBFBF"))
                                        .rotationEffect(viewModel.showColorOptions ? .degrees(90) : .degrees(0))
                                }
                            }
                            .padding(.top, viewModel.showColorOptions ? 10 : 0)
                    }

                    if viewModel.showColorOptions {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(Color.overcastColors, id: \.self) { colorHex in
                                    Button {
                                        viewModel.selectedColorHex = colorHex
                                    } label: {
                                        Circle()
                                            .frame(height: 20)
                                            .foregroundColor(.hexStringToColor(hex: colorHex))
                                            .overlay {
                                                Circle()
                                                    .stroke(lineWidth: 1)
                                                    .foregroundColor(.gray)
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
            } header: {
                Text("Info").hidden()
            }
            
            Section("Start time") {
                DatePicker("Start Time", selection: $viewModel.start,
                           in: viewModel.shift.getStart() ... viewModel.shift.getEnd(),
                           displayedComponents: .hourAndMinute)
                
                Button("Set current time") {
                    viewModel.start = .now
                }
//                .frame(maxWidth: .infinity, alignment: .trailing)
            }
//            .listRowSeparator(.hidden)
            
            Section("End time") {
                DatePicker("End Time", selection: $viewModel.end,
                           in: viewModel.shift.getStart() ... viewModel.shift.getEnd(),
                           displayedComponents: .hourAndMinute)
                
                Button("Set current time") {
                    viewModel.end = .now
                }
//                .frame(maxWidth: .infinity, alignment: .trailing)
            }
//            .listRowSeparator(.hidden)

            Section {
                ForEach(viewModel.pastBlocks, id: \.self) { block in
                    if let recent = block.actualBlocks(viewModel.user).first,
                       let recentEnd = recent.endTime,
                       let recentStart = recent.startTime {
                        Button {
                            viewModel.title = block.title
                            viewModel.start = recentStart
                            viewModel.end = recentEnd
                        } label: {
                            HStack {
                                Components.coloredBar(block.color)
                                VStack(alignment: .leading) {
                                    Text(block.title)
                                        .font(.subheadline)

                                    Text(recentEnd.getFormattedDate(format: .abbreviatedMonth))
                                        .font(.caption)
                                }
                                Spacer()

                                Text(recent.timeRangeString())
                                    .font(.caption)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                if viewModel.pastBlocks.isEmpty {
                    Text("No recent time blocks yet.")
                }
            } header: {
                Text("Recent")
            } footer: {
                if !viewModel.pastBlocks.isEmpty {
                    Text("Tap to autofill Title field")
                }
                
            }
        }
        .navigationTitle("Create TimeBlock")

        .putInTemplate()
        .alert(isPresented: $viewModel.showErrorAlert, error: viewModel.error) {}
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.title.isEmpty == false,
                   viewModel.start != viewModel.end {
                    Button("Save") {
                        do {
                            try viewModel.saveAction(context: viewContext)
                            dismiss()
                        } catch {
                            print("error")
                        }
                    }
                }
            }

            ToolbarItemGroup(placement: .keyboard) {
                Button("Clear") {
                    viewModel.title = ""
                }
                Spacer()
                Button("Done") {
                    titleFocused = false
                }
            }
        }

//        .conditionalModifier(viewModel.title.isEmpty == false) { thisView in
//            thisView
//                .bottomButton(label: "Save") {
//                    try? viewModel.saveAction(context: viewContext)
//                }
//        }
    }

    struct TimeBlockStarter_Shift: Equatable, Hashable {
        let start: Date?
        let end: Date?
        let shift: Shift
    }

    struct TimeBlockStarter_Today: Equatable, Hashable {
        let start: Date?
        let end: Date?
        let todayShift: TodayShift
    }
}



// MARK: - CreateNewTimeBlockView_Previews

struct CreateNewTimeBlockView_Previews: PreviewProvider {
    static let user: User = {
        let user = User.main
        user.instantiateExampleItems(context: PersistenceController.context)
//        user.getTimeBlocksBetween().forEach({ PersistenceController.context.delete($0) })
//        try! user.getContext().save()
        return user
    }()

    static var previews: some View {
        CreateNewTimeBlockView(.init(start: nil, end: nil, shift: User.main.getShifts().first!))
            .putInNavView(.inline)
    }
}
