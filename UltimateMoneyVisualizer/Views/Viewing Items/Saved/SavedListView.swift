//
//  SavedListView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//

import SwiftUI

struct SavedListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Saved.date, ascending: false)],
        predicate: NSPredicate(format: "user == %@", User.main),
        animation: .default)
    private var savedItems: FetchedResults<Saved>
    
    var body: some View {
            List {
                ForEach(savedItems) { saved in
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
            .putInTemplate()
            .navigationTitle("Saved Items")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
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

struct SavedListView_Previews: PreviewProvider {
    static var previews: some View {
        SavedListView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}

