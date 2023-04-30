//
//  ConfirmTodayShiftView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/29/23.
//

import SwiftUI

struct ConfirmTodayShiftView: View {
    
    
    var todayShift: TodayShift
    
    @State private var tempAllocations: [TemporaryAllocation] = []
    
    var body: some View {
        Form {
            Section("Spent") {
                ForEach(tempAllocations) { allocation in
                    if let expense = allocation.expense {
                        Text(expense.titleStr)
                            .spacedOut(text: expense.amountMoneyStr)
                    }
                    if let goal = allocation.goal {
                        Text(goal.titleStr)
                            .spacedOut(text: goal.amountMoneyStr)
                    }
                }
            }
        }
        .onAppear {
            
        }
    }
}

struct ConfirmTodayShiftView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmTodayShiftView(todayShift: try! TodayShift(startTime: .nineAM, endTime: .fivePM, user: User.main, context: PersistenceController.testing))
            .putInNavView(.inline)
    }
}
