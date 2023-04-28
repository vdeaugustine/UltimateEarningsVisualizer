//
//  AssignAllocationView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/27/23.
//

import SwiftUI

struct AssignAllocationForExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var note: String = ""
    let expense: Expense
    @State private var goal: Goal?
    @State private var shift: Shift?
    @State private var saved: Saved?
    
    
    var body: some View {
        Form {
            
            
            
            
            
            
        }
    }
}

//struct AssignAllocationForExpenseView_Previews: PreviewProvider {
//    static var previews: some View {
//        AssignAllocationForExpenseView(expense: )
//    }
//}
