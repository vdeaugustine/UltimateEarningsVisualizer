//
//  AllocSavedRow.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/7/23.
//

import SwiftUI

// MARK: - AllocSavedRow

struct AllocSavedRow: View {
    let saved: Saved
    let allocation: Allocation
    @ObservedObject private var settings = User.main.getSettings()
    @ObservedObject private var user = User.main

    var body: some View {
        HStack {
            Image("green.background.pig")
                .resizable()
                .frame(width: 35, height: 35)
                .cornerRadius(8)
//                .foregroundColor(.white)
//
//                .background(settings.getDefaultGradient())
//                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(saved.getTitle())
                    .font(.subheadline)
                    .foregroundColor(.primary)

                Text("SAVED")
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
                Text(user.convertMoneyToTime(money: allocation.amount).formatForTime([.hour, .minute, .second]).uppercased())
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 1)
    }
}

#if DEBUG
// MARK: - AllocSavedRow_Previews

struct AllocSavedRow_Previews: PreviewProvider {
    
    static let saved = try! Saved(amount: 12, title: "Didn't go to lunch", date: .now, user: User.main, context: PersistenceController.context)
    static let alloc = try! Allocation(amount: 12, goal: .disneyWorld, saved: saved)
    
    static var previews: some View {
        AllocSavedRow(saved: saved,
                      allocation: alloc)
    }
}

#endif
