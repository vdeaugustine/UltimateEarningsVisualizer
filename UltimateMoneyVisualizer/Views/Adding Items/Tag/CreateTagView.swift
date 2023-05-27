//
//  CreateTagView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/25/23.
//

import SwiftUI
import AlertToast

struct CreateTagView: View {
    
    var goal: Goal?
    var expense: Expense?
    var saved: Saved?
    
   
    @State private var tagTitle = ""
    @State private var symbolStr = Tag.defaultSymbolStr
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var user = User.main
    @Environment (\.dismiss) private var dismiss
    
    @State private var showAlert = false
    @State private var alertConfig = AlertToast.successWith(message: "")
    
    @State private var colorSelected: Color = User.main.getSettings().themeColor
    
    @State private var showColorOptions = false
    
    let symbolWidthHeight: CGFloat = 40
    
    var body: some View {
        Form {
            Section("Tag Title") {
                TextField("Ex: Groceries", text: $tagTitle)
                if !symbolStr.isEmpty {
                    HStack {
                        Text("Symbol")
                        Spacer()
                        SystemImageWithFilledBackground(systemName: symbolStr, backgroundColor: colorSelected, width: symbolWidthHeight, height: symbolWidthHeight)
                            
                    }
                        
                }
            }
            
            Section("Color") {
                Button {
                    withAnimation {
                        showColorOptions.toggle()
                    }

                } label: {
                    Text("Color (PREMIUM)")
                        .foregroundColor(.black)
                        .spacedOut {
                            HStack {
                                Circle()
                                    .fill(colorSelected)
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
                                    .rotationEffect(showColorOptions ? .degrees(90) : .degrees(0))
                            }
                        }
                }

                if showColorOptions {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(Color.defaultColorOptions, id: \.self) { color in
                                Button {
                                    colorSelected = color
                                } label: {
                                    Circle()
                                        .frame(height: 20)
                                        .foregroundColor(color)
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
            
            
            Section("Select New Symbol") {
                SFSymbolsPicker(selectedSymbol: $symbolStr, numberOfColumns: 5, width: symbolWidthHeight, height: symbolWidthHeight, color: colorSelected)
                    .padding(.vertical)
            }
        }
        .putInTemplate()
        .navigationTitle("Create Tag")
        .bottomButton(label: "Save") {
            do {
                
                if let goal {
                    try Tag(tagTitle, symbol: symbolStr, color: colorSelected, goal: goal, user: user, context: viewContext)
                }
                else if let expense {
                    try Tag(tagTitle, symbol: symbolStr, color: colorSelected, expense: expense, user: user, context: viewContext)
                }
                else if let saved {
                    try Tag(tagTitle, symbol: symbolStr, color: colorSelected, savedItem: saved, user: user, context: viewContext)
                }
                else {
                    try Tag(tagTitle, symbol: symbolStr, color: colorSelected, user: user, context: viewContext)
                }
               
                try viewContext.save()
                alertConfig = .successWith(message: "Saved successfully")
                showAlert.toggle()
                dismiss()
            }
            catch {
                alertConfig = .errorWith(message: "Error saving. Please try again")
                showAlert.toggle()
            }
        }
        .toast(isPresenting: $showAlert) {
            alertConfig
        }
    }
}

struct CreateTagView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTagView()
        .environment(\.managedObjectContext, PersistenceController.context)
        .putInNavView(.inline)
    }
}
