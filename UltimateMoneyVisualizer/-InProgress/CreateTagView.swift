//
//  CreateTagView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/25/23.
//

import SwiftUI
import AlertToast

struct CreateTagView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var tagTitle = ""
    @State private var symbolStr = ""
    @ObservedObject private var user = User.main
    @Environment (\.dismiss) private var dismiss
    
    @State private var showAlert = false
    @State private var alertConfig = AlertToast.successWith(message: "")
    
    let symbolWidthHeight: CGFloat = 50
    
    var body: some View {
        Form {
            Section("Tag Title") {
                TextField("Ex: Groceries", text: $tagTitle)
                if !symbolStr.isEmpty {
                    HStack {
                        Text("Symbol")
                        Spacer()
                        SystemImageWithFilledBackground(systemName: symbolStr, backgroundColor: user.getSettings().themeColor, width: symbolWidthHeight, height: symbolWidthHeight)
                    }
                        
                }
            }
            
            
            
            Section("Select New Symbol") {
                
                
                SFSymbolsPicker(selectedSymbol: $symbolStr, numberOfColumns: 5, width: symbolWidthHeight, height: symbolWidthHeight)
            }
        }
        .putInTemplate()
        .navigationTitle("Create Tag")
        .bottomButton(label: "Save") {
            do {
               try Tag(tagTitle, symbol: symbolStr, user: user, context: viewContext)
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
