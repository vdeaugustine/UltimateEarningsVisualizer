//
//  SavedListView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import AlertToast
import SwiftUI

// MARK: - SavedListView

struct SavedListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var searchText: String = ""
    @ObservedObject private var user = User.main

    @State private var alertConfig = AlertToast(displayMode: .alert, type: .complete(User.main.getSettings().themeColor))

    @State private var savedItems = User.main.getSaved()
    @State private var showAlert = false

    var body: some View {
        List {
            ForEach(savedItems) { saved in
                NavigationLink {
                    
                    SavedDetailView(saved: saved)
                    
                } label: {
                    HStack {
                        
                        DateCircle(date: saved.getDate(), height: 40)
                            
                        
                        VStack(alignment: .leading) {
                            Text(saved.getTitle())
                                .font(.headline)
                            Text(saved.getAmount().formattedForMoney())
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(user.getSettings().getDefaultGradient())
                        }
                    }
                }
            }
        }

        .putInTemplate()
        .navigationTitle("Saved Items")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    CreateSavedView()
                } label: {
                    Label("Add Saved Item", systemImage: "plus")
                }
            }
           
        }
    }

    private func addSavedItem() {
        withAnimation {
            let newSavedItem = Saved(context: viewContext)
            newSavedItem.date = Date()
            do {
                try viewContext.save()
            } catch {
                alertConfig = .errorWith(message: "Error saving new saved item: \(error)")
                showAlert = true
            }
        }
    }


}



// MARK: - SavedListView_Previews

struct SavedListView_Previews: PreviewProvider {
    static var previews: some View {
        SavedListView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
