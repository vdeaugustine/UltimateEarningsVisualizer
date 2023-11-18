//
//  TimeBlocksStatsView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/25/23.
//

import SwiftUI

// MARK: - TimeBlocksStatsView

/*
 Include:
 - Total time blocked
 - Total time not blocked
 - Total earned blocked
 - Total earned not blocked
 - Favorite Color
 - Longest Single Block
 */

struct TimeBlocksStatsView: View {
    @ObservedObject private var user: User = .main
    var body: some View {
        VStack {
            HStack {
                Text("Stats")
                    .font(.title3)
                    .bold()
                Spacer()
            }

            DataRect(top: user.totalTimeBlockedBetween().breakDownTime(),
                     bottom: "Time Blocked")
            
            VStack {
                ForEach(Array(user.timeBlockColorsDict().keys), id: \.self) { key in
                    if let value = user.timeBlockColorsDict()[key] {
                        Text(value.str)
                    }
                    
                }
            }
        }
        .padding()
        .background(
            Color(.tertiarySystemBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        )
    }

    var timeNotBlocked: TimeInterval {
        user.totalTimeWorked() - user.totalTimeBlockedBetween()
    }
}

extension TimeBlockStatsView {
}

#Preview {
    ZStack {
        Color(.quaternarySystemFill)
        TimeBlocksStatsView()
            .frame(height: 400.0)
    }
}

// MARK: - DataRect

struct DataRect: View {
    let top: String
    let bottom: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(top)
                .font(.title3)
                .fontWeight(.semibold)
            Text(bottom)
                .font(.footnote)
        }
        .padding(15, 10)
        .background(
            Color(.secondarySystemFill)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        )
    }
}
