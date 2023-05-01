//
//  SavedListView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI

// MARK: - SavedListView

struct SavedListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Saved.date, ascending: false)],
                  predicate: NSPredicate(format: "user == %@", User.main),
                  animation: .default)
    private var savedItems: FetchedResults<Saved>
    @State private var searchText: String = ""

    var showItems: [Saved] {
        let unfiltered = Array(savedItems)
        if searchText.isEmpty {
            return unfiltered
        }

        return unfiltered.filter {
            guard let info = $0.info,
                  let title = $0.title
            else { return false }

            return info.contains(searchText) || title.contains(searchText)
        }
    }

    var body: some View {
        List {
            ForEach(showItems) { saved in
                NavigationLink(destination: SavedDetailView(saved: saved)) {
                    VStack(alignment: .leading) {
                        Text(saved.title ?? "")
                            .font(.headline)
                        Text(saved.info ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .onDelete(perform: deleteSavedItems)
        }
        .searchable(text: $searchText)
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
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
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
                print("Error saving new saved item: \(error)")
            }
        }
    }

    private func deleteSavedItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { savedItems[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting saved items: \(error)")
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
