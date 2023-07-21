//
//  AllocShiftRow.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/7/23.
//

import SwiftUI

struct AllocShiftRow: View {
    
    let shift: Shift
    let allocation: Allocation
    @ObservedObject private var settings = User.main.getSettings()
    @ObservedObject private var user = User.main
    
    var body: some View {
        HStack {
            Text(shift.start.firstLetterOrTwoOfWeekday())
                .foregroundColor(.white)
                .frame(width: 35, height: 35)
                .background(settings.getDefaultGradient())
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(shift.start.getFormattedDate(format: .abreviatedMonth))
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Text("SHIFT")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            Spacer()

            VStack {
                Text(allocation.amount.money())
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.trailing)
                Text(user.convertMoneyToTime(money: allocation.amount).formatForTime([.hour,.minute,.second]).uppercased())
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
            }
        }
        .padding(.vertical, 1)
    }
}

struct AllocShiftRow_Previews: PreviewProvider {
    static var previews: some View {
        AllocShiftRow(shift: User.main.getShifts().first!, allocation: User.main.getShifts().first!.getAllocations().first!)
            .environment(\.managedObjectContext, PersistenceController.context)
    }
}
