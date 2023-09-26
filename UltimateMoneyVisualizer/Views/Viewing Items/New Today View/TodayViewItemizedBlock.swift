//
//  TodayViewItemizedBlock.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/10/23.
//

import SwiftUI

// MARK: - TodayViewItemizedBlock

struct TodayViewItemizedBlock: View {
    let block: TimeBlock
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(block.getColor())
                .frame(width: 3)
                .padding(.vertical, 5)

            VStack(alignment: .leading) {
                Text(block.getTitle())
                    .font(.callout)
                    .fontWeight(.heavy)

                Text(block.timeRangeString())
                    .format(size: 14)
                Text(block.duration.breakDownTime())
                    .format(size: 14)
            }
            .lineLimit(1)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            Color(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .modifier(ShadowForRect())
        }
        .frame(height: 100)
        
    }
}



// MARK: - TodayViewExampleItemizedBlock

struct TodayViewExampleItemizedBlock: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.defaultColorOptions.first!)
                .frame(width: 3)
                .padding(.vertical, 5)

            VStack(alignment: .leading) {
                Text("Example time block")
                    .font(.callout)
                    .fontWeight(.heavy)

                Text("10:00 - 11:30 AM")
                    .format(size: 14)
                Text("1h 30m")
                    .format(size: 14)
            }
            .lineLimit(1)
        }
        .padding()
        .background {
            Color(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .modifier(ShadowForRect())
//                .shadow(color: .black.opacity(0.25), radius: 2, x: 1, y: 3)
        }
        
        .frame(height: 100)
    }
}

struct TodayViewItemizedBlock_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewItemizedBlock(block: User.main.getTimeBlocksBetween().first!)
        TodayViewExampleItemizedBlock()
    }
}
