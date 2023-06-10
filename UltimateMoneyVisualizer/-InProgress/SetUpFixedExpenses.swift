//
//  SetUpFixedExpenses.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 6/10/23.
//

import SwiftUI

struct SetUpFixedExpenses: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var user = User.main
    var body: some View {
        List {
            Section("Fixed Expenses") {
                ForEach(user.getPercentShiftExpenses()) { expense in
                    if let title = expense.title {
                        Text(title)
                    }
                    
                }
            }
        }
    }
}

struct SetUpFixedExpenses_Previews: PreviewProvider {
    static var previews: some View {
        SetUpFixedExpenses()
        .environment(\.managedObjectContext, PersistenceController.context)
    }
}
