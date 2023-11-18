//
//  AllItemsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/10/23.
//

import SwiftUI

// MARK: - AllItemsView

struct AllItemsView: View {
    @EnvironmentObject private var navManager: NavManager
    @ObservedObject private var user = User.main
    @ObservedObject private var settings = User.main.getSettings()
    @State private var selectionType: SelectionType = .shifts
    @State private var editMode: EditMode = .inactive

    var body: some View {
        VStack(spacing: 0) {
            Picker("Selection", selection: $selectionType) {
                ForEach(SelectionType.allCases, id: \.self) {
                    Text($0.rawValue.capitalized).tag($0)
                }
            }
            .pickerStyle(.segmented)
            .padding([.horizontal, .top])
            .onChange(of: selectionType) { _ in editMode = .inactive }

            switch selectionType {
                case .goals:
                    NewPayoffList(payoffType: .goal)
                case .saved:
                    SavedListView()
                case .shifts:
                    ShiftListView()
                case .expenses:
                    NewPayoffList(payoffType: .expense)
            }
        }
        .background(Color.listBackgroundColor)
        
        .environment(\.editMode, $editMode)

//        .gesture(
//            DragGesture()
//                .onEnded { value in
//                    if value.translation.width < 0 {
//                        // Swiped to the left
//                        changeSelectionType(forward: true)
//                    } else if value.translation.width > 0 {
//                        // Swiped to the right
//                        changeSelectionType(forward: false)
//                    }
//                }
//        )
        .navigationDestination(for: NavManager.AllViews.self) { view in
            navManager.getDestinationViewForStack(destination: view)
        }

        .toolbar {
            // TODO: Get rid of this
            #if DEBUG
            ToolbarItem(placement: .navigationBarLeading) {
                
                Menu("Debug") {
                    Button("Delete all shifts") {
                        for shift in user.getShifts() {
                            do {
                                let context = user.getContext()
                                user.removeFromShifts(shift)
                                context.delete(shift)
                                try context.save()
                                print("Deleted shift")
                            } catch {
                                fatalError(String(describing: error))
                            }
                        }
                    }
                }
            }
            #endif
        }
        
        .putInTemplate()
    }

    private func changeSelectionType(forward: Bool) {
        guard let currentIndex = SelectionType.allCases.firstIndex(of: selectionType) else {
            return
        }

        var newIndex: Int
        if forward {
            newIndex = currentIndex + 1
            if newIndex >= SelectionType.allCases.count {
                newIndex = 0
            }
        } else {
            newIndex = currentIndex - 1
            if newIndex < 0 {
                newIndex = SelectionType.allCases.count - 1
            }
        }

        selectionType = SelectionType.allCases[newIndex]
    }
}

extension AllItemsView {
    enum SelectionType: String, CaseIterable {
        case shifts, saved, expenses, goals
    }
}

// MARK: - AllItemsView_Previews

struct AllItemsView_Previews: PreviewProvider {
    static var previews: some View {
        AllItemsView()
            .environment(\.managedObjectContext, PersistenceController.context)
            .putInNavView(.inline)
    }
}
