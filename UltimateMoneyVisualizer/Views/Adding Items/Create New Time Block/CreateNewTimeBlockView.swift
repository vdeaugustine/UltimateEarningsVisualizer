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
    @StateObject private var viewModel: CreateNewTimeBlockViewModel

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
                DatePicker("Start Time", selection: $viewModel.start,
                           in: viewModel.shift.getStart() ... viewModel.shift.getEnd(),
                           displayedComponents: .hourAndMinute)
                DatePicker("End Time", selection: $viewModel.end,
                           in: viewModel.shift.getStart() ... viewModel.shift.getEnd(),
                           displayedComponents: .hourAndMinute)
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

            Section {
                ForEach(viewModel.titles, id: \.self) { blockTitle in
                    Text(blockTitle)
                        .allPartsTappable(alignment: .leading)
                        .onTapGesture {
                            viewModel.title = blockTitle
                        }
                }
            } header: {
                Text("Recent")
            } footer: {
                Text("Tap to autofill Title field")
            }
        }
        .navigationTitle("Create TimeBlock")
        .putInTemplate()
        .conditionalModifier(viewModel.title.isEmpty == false) { thisView in
            thisView
                .bottomButton(label: "Save") {
                    viewModel.saveAction(context: viewContext)
                }
        }
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
    static var previews: some View {
        CreateNewTimeBlockView(.init(start: nil, end: nil, shift: User.main.getShifts().first!))
            .putInNavView(.inline)
    }
}
