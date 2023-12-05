//
//  NewItemCreationView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/5/23.
//

import SwiftUI

// MARK: - NewItemCreationView

struct NewItemCreationView: View {
    @StateObject private var viewModel: NewItemViewModel = .shared

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 20) {
                        Picker("Item Type", selection: $viewModel.selectedType) {
                            ForEach(NewItemViewModel.SelectedType.allCases) { type in
                                Text(type.rawValue.capitalized)
                                    .id(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding([.horizontal, .top], 5)
                  

                    VStack {
                        Text(viewModel.timeLabelPrefix)
                            .fontWeight(.medium)
                            .minimumScaleFactor(0.01)
                        Text(viewModel.toTime.breakDownTime())
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.01)
                        
                        Divider().padding(.horizontal)
                    }
                    .font(.title2)

                    EnterDoublePart(viewModel: viewModel, geo: geo)
                }
                .frame(maxHeight: .infinity)
                
            }
        }
        
        .navigationTitle("Enter")
        .putInTemplate()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.navManager.appendCorrectPath(newValue: viewModel.getViewType())
                } label: {
                    Label("Next", systemImage: "chevron.right")
                        .labelStyle(.titleOnly)
                }
                
            }
        }
        .environmentObject(viewModel)
    }
    
    
    

    struct EnterDoublePart: View {
        @ObservedObject var viewModel: NewItemViewModel
        let geo: GeometryProxy
        var body: some View {
            VStack {
                Menu {
                    Button {
                        let pasteboard = UIPasteboard.general
                        if let clipboardString = pasteboard.string,
                           let number = Double(clipboardString) {
                            viewModel.enteredStr = "\(Int(number * 100))"
                        }

                    } label: {
                        Label("Paste", systemImage: "doc.on.clipboard")
                    }
                } label: {
                    Text(viewModel.formattedString)
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 55))
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal)
                }

                ForEach(viewModel.numbers, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { num in
                            Button {
                                if viewModel.enteredStr == "0" {
                                    viewModel.enteredStr = ""
                                }
                                if viewModel.enteredStr.count < 11 {
                                    viewModel.append(num)
                                }

                            } label: {
                                Text("\(num)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(width: geo.size.width * 100 / 375,
                                           height: 75)
                                    .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                            }
                        }
                    }
                }

                HStack {
                    Button {
                        if viewModel.formattedString.contains(".") {
                            viewModel.enteredStr = ""
                        } else {
                            viewModel.enteredStr += "."
                        }

                    } label: {
                        if viewModel.formattedString.contains(".") {
                            Image(systemName: "clear")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: geo.size.width * 100 / 375,
                                       height: 75)
                                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                        } else {
                            Text(".")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: geo.size.width * 100 / 375,
                                       height: 75)
                                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                        }
                    }

                    Button {
                        viewModel.enteredStr += "0"
                    } label: {
                        Text("0")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: geo.size.width * 100 / 375, height: 75)
                            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                    }

                    Button {
                        _ = viewModel.enteredStr.popLast()
                    } label: {
                        Image(systemName: "delete.left")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: geo.size.width * 100 / 375, height: 75)
                            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.white).shadow(radius: 1))
                    }
                }
            }
//            .foregroundStyle(viewModel.settings.themeColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onChange(of: viewModel.enteredStr) { newValue in
                if newValue.isEmpty {
                    viewModel.enteredStr = "0"
                }
            }
        }
    }
}

// MARK: - NewItemCreationView_Previews

struct NewItemCreationView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemCreationView()
            .putInNavView(.inline)
    }
}
