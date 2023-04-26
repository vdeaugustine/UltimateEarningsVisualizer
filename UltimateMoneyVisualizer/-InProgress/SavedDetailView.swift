//
//  SavedDetailView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/26/23.
//


import SwiftUI

// MARK: - SavedDetailView

struct SavedDetailView: View {
    var saved: Saved

    var body: some View {
        VStack {
            Text(saved.title ?? "")
                .font(.largeTitle)
            Text("\(saved.amount)")
                .font(.headline)
                .foregroundColor(.secondary)
            Text(saved.info ?? "")
                .font(.body)
        }
        .navigationTitle("Saved Detail")
    }
}

// MARK: - SavedDetailView_Previews

struct SavedDetailView_Previews: PreviewProvider {
    static let context = PersistenceController.preview.container.viewContext

    static let saved: Saved = {
        let saved = Saved(context: context)

        saved.title = "Test saved"
        saved.amount = 1000
        saved.info = "this is a test description"
        saved.date = Date()

        return saved
    }()

    static var previews: some View {
        SavedDetailView(saved: saved)
    }
}





