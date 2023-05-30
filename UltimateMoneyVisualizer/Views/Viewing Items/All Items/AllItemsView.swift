//
//  AllItemsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/10/23.
//

import SwiftUI

struct AllItemsView: View {
    
    @ObservedObject private var user = User.main
    @ObservedObject private var settings = User.main.getSettings()
    @State private var selectionType: SelectionType = .shifts

    var body: some View {
        VStack(spacing: 0) {
            Picker("Selection", selection: $selectionType) {
                ForEach(SelectionType.allCases, id: \.self) {
                    Text($0.rawValue.capitalized).tag($0)
                }
            }
            .pickerStyle(.segmented)
            .padding([.horizontal, .top])
            
            switch selectionType {
            case .goals:
                GoalListView()
            case .saved:
                SavedListView()
            case .shifts:
                ShiftListView()
            case .expenses:
                ExpenseListView()
            }
            
           
        }
        .background(Color.listBackgroundColor)
        .tint(settings.themeColor)
        .putInTemplate()
        
        
    }
    
//
//    var shiftsView: some View {
//        List {
//            ForEach(user.getShifts()) { shift in
//                Text(shift.start.getFormattedDate(format: .abreviatedMonth))
//            }
//        }
//    }
    
    
    
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

