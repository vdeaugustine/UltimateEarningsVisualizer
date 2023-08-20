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
    @State private var alertConfig = AlertToast(displayMode: .alert,
                                                type: .complete(User.main.getSettings().themeColor))
    @State private var savedItems = User.main.getSaved()
    @State private var showAlert = false
    @FocusState var searchFocused
    @State private var showSearch = false
    
    var filteredItems: [Saved] {
        if searchText.isEmpty {
            return savedItems
        }
        return savedItems.filter { item in
            item.getTitle().removingWhiteSpaces().lowercased().contains(searchText.removingWhiteSpaces().lowercased())
        }
    }
    
   

    var body: some View {
        List {
            Section {
                ForEach(filteredItems) { saved in
                    if saved.title != nil,
                       saved.date != nil,
                       saved.amount > 0 {
                        NavigationLink {
                            SavedDetailView(saved: saved)
                        } label: {
                            SavedItemRow(saved: saved, user: user)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        if let item = savedItems.safeGet(at: index) {
                            viewContext.delete(item)
                            savedItems.removeAll(where: { $0 == item })
                        }
                    }
                })
            } header: {
                Text("Items").hidden()
            }
        }
        
//        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.immediately)
        .putInTemplate()
        .navigationTitle("Saved Items")
        .toolbar {
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSearch.toggle()
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    CreateSavedView()
                } label: {
                    Label("Add Saved Item", systemImage: "plus")
                }
            }
        }
        
        .conditionalModifier(showSearch) { view in
            view
                .searchable(text: $searchText)
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

// MARK: - SavedItemRow

struct SavedItemRow: View {
    let saved: Saved
    @ObservedObject var user: User
    var body: some View {
        HStack {
            if let title = saved.title,
               let date = saved.date,
               saved.amount > 0 {
                DateCircle(date: date, height: 40)

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                }

                Spacer()
                Text(saved.amount.money())
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(user.getSettings().getDefaultGradient())
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
