//
//  TodayViewItemizedBlock.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/10/23.
//

import SwiftUI
import Vin

// MARK: - TodayViewItemizedBlock

struct TodayViewCondensedTimeBlock: View {
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


struct ExampleTimeBlockCompact: View {
    let title: String
    var start: Date = .now.addHours(-0.4)
    var end: Date = .now.addHours(1)
    var color: Color = .blue
    var hourlyWage: Double = 20
    
    var duration: Double {
        end - start
    }
    var earnings: Double {
        duration / 3600 * hourlyWage
    }
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 3)
                .padding(.vertical, 5)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.callout)
                    .fontWeight(.heavy)

                VStack(alignment: .leading) {
                    Text("\(start.getFormattedDate(format: "hh:mm")) - \(end.getFormattedDate(format: .minimalTime))")
//                        .format(size: 14)
                        
                        
                    HStack {
                        Text(duration.breakDownTime())
                        Text("•")
                        Text(earnings.money())
                        
                        
                    }
                }
                .font(.footnote)
            }
            .lineLimit(1)
        }
        .padding()
        .background {
            UIColor.systemBackground.color
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .modifier(ShadowForRect())
//                .shadow(color: .black.opacity(0.25), radius: 2, x: 1, y: 3)
        }

        .frame(idealHeight: 100, maxHeight: 120)
    }
}

// MARK: - TodayViewItemizedBlock_Previews

struct TodayViewItemizedBlock_Previews: PreviewProvider {
    static let user: User = {
        let user = User(context: PersistenceController.testing)
        user.instantiateExampleItems(context: PersistenceController.testing)
        let timeBlock = try! TimeBlock(title: "This is a test time block",
                                  start: .now.addHours(-1),
                                  end: .now.addHours(0.4),
                                  colorHex: Color.yellow.hex,
                                  user: user,
                                  context: PersistenceController.testing)
        return user
    }()

    static var previews: some View {
        VStack {
            ExampleTimeBlockCompact(title: "Testing ex")
            TodayViewCondensedTimeBlock(block: try! TimeBlock(title: "This is a test time block",
                                                         start: .now.addHours(-1),
                                                         end: .now.addHours(0.4),
                                                         colorHex: Color.yellow.hex,
                                                         user: user,
                                                         context: PersistenceController.testing))
            TodayViewExampleItemizedBlock()
        }
    }
}
