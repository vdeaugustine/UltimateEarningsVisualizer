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
        animation: .default)
    private var savedItems: FetchedResults<Saved>
    
    var body: some View {
            List {
                ForEach(savedItems, id: \.self) { saved in
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
            .navigationTitle("Saved Items")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: addSavedItem) {
                        Image(systemName: "plus")
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
        let context = PersistenceController.context
        let savedItem1 = Saved(context: context)
        savedItem1.title = "Saved Item 1"
        savedItem1.date = Date()
        let savedItem2 = Saved(context: context)
        savedItem2.title = "Saved Item 2"
        savedItem2.date = Date()
        return SavedListView()
            .environment(\.managedObjectContext, context)
    }
}

