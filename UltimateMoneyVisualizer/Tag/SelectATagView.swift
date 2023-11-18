//
//  SelectATagView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/23/23.
//

import SwiftUI

// MARK: - SelectATagView

struct SelectATagView: View {

    let errorMessage: String = "Please try again or restart the app."
    let item: PayoffItem
    @State private var errorTitle: String = ""
    @State private var selectedTag: Tag? = nil
    @State private var showConfirmation = false
    @State private var showErrorAlert = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(User.main.getTags()) { tag in
                        Button {
                            selectedTag = tag
                            showConfirmation.toggle()
                        } label: {
                            TagRow(tag: tag, variation: 2)
                        }
                        .foregroundStyle(Color.black)
                    }
                } header: {
                    Text("Tags").hidden()
                }
            }
            .putInTemplate(title: "Tags")
            .confirmationDialog("Add this tag to \(item.titleStr)?", isPresented: $showConfirmation, titleVisibility: .visible) {
                Button("Yes") {
                    if let selectedTag {
                        do {
                            try item.addTag(tag: selectedTag)
                            dismiss()
                        } catch {
                            errorSaving()
                        }

                    } else {
                        nilSelected()
                    }
                }
            }

            .alert(errorTitle, isPresented: $showErrorAlert) {} message: {
                Text(errorMessage)
            }
        }
    }

    func nilSelected() {
        errorTitle = "Error selecting this tag."
        showErrorAlert.toggle()
    }

    func errorSaving() {
        errorTitle = "Error adding this tag to \(item.titleStr)."
        showErrorAlert.toggle()
    }
}

// MARK: - SelectATagView_Previews

struct SelectATagView_Previews: PreviewProvider {
    static let item = User.main.getGoals().first!
    static var previews: some View {
        SelectATagView(item: item)
    }
}
