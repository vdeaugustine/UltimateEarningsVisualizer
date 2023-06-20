//
//  CreateNewTimeBlockView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/3/23.
//

import SwiftUI
import CoreData

struct CreateNewTimeBlockView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var viewModel: CreateNewTimeBlockViewModel

    init(shift: Shift) {
        self.viewModel = CreateNewTimeBlockViewModel(shift: shift)
    }

    var body: some View {
        Form {
            TextField("Title", text: $viewModel.title)
            DatePicker("Start Time", selection: $viewModel.start,
                       in: viewModel.shift.start ... viewModel.shift.end,
                       displayedComponents: .hourAndMinute)
            DatePicker("End Time", selection: $viewModel.end,
                       in: viewModel.shift.start ... viewModel.shift.end,
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
}



struct CreateNewTimeBlockView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewTimeBlockView(shift: User.main.getShifts().first!)
            .putInNavView(.inline)
    }
}
