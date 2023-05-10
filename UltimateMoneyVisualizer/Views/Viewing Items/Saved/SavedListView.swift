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

//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Saved.date, ascending: false)],
//                  predicate: NSPredicate(format: "user == %@", User.main),
//                  animation: .default)
//    private var savedItems: FetchedResults<Saved>
    @State private var searchText: String = ""
    @ObservedObject private var user = User.main
    @State private var showAlert = false
    @State private var alertConfig = AlertToast(displayMode: .alert, type: .complete(User.main.getSettings().themeColor))
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Saved.date, ascending: false)],
                      predicate: NSPredicate(format: "user == %@", User.main),
                      animation: .default)
        private var savedItems: FetchedResults<Saved>
//    @State private var savedItems = User.main.getSaved()

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
            
            Button("Delete") {
                
                guard let item = showItems.first else {
                    print("no item")
                    return
                }
                user.removeFromSavedItems(item)
                viewContext.delete(item)
                
                
                
            }
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
//        .toast(isPresenting: $showAlert, alert: {alertConfig})
    }

    private func addSavedItem() {
        withAnimation {
            let newSavedItem = Saved(context: viewContext)
            newSavedItem.date = Date()
            do {
                try viewContext.save()
                alertConfig = .successWith(message: "Successfully added item.")
            } catch {
                alertConfig = .errorWith(message: "Error saving new saved item: \(error)")
                showAlert = true
            }
        }
    }

    private func deleteSavedItems(offsets: IndexSet) {
        offsets.map { savedItems[$0] }.forEach {
            user.removeFromSavedItems($0)
            user.managedObjectContext!.delete($0)
        }
        do {
            try viewContext.save()
            print("Saved successfully")
//            alertConfig = .successWith(message: "Successfully deleted item.")
//            showAlert = true
        } catch {
            print("Saved")
//            alertConfig = .errorWith(message: "Error deleting saved items: \(error)")
//            showAlert = true
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
