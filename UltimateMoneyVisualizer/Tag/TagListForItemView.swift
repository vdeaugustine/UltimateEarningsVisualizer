//
//  TagListForItemView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/21/23.
//

import SwiftUI

// MARK: - TagListForItemView

struct TagListForItemView: View {
    let item: PayoffItem
    @Environment(\.dependencies) private var deps

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(item.getTags()) { tag in
                        Button {
                            deps.navigator.push(.tagDetail(tag))
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            deps.navigator.push(.createTag(AnyPayoffItem(item)))
                        } label: {
                        Label("New", systemImage: "plus")
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

// MARK: - TagListForItemView_Previews

struct TagListForItemView_Previews: PreviewProvider {
    static var previews: some View {
        TagListForItemView(item: User.main.getGoals().first!)
            .putInNavView(.large)
    }
}
