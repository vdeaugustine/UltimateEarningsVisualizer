//
//  ExpenseGridBlock.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/8/23.
//

import SwiftUI
import Vin

// MARK: - ExpenseGridBlock

struct ExpenseGridBlock: View {
    let expense: Expense
    let user: User
    var unit: NSCalendar.Unit {
        return timeComponent > 1_000 ? NSCalendar.Unit.minute : NSCalendar.Unit.second
    }
    
    @State private var nowTime: Date = .now

    var timeComponent: Double {
        guard let dueDate = expense.dueDate else { return 0 }
        return dueDate - nowTime
//        user.convertMoneyToTime(money: expense.amount)
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
        

    var timeString: String {
        if let dueDate = expense.dueDate {
            if abs(timeComponent) < 86_400 {
                let hours = Int(timeComponent / 3_600)
                let minutes = Int((timeComponent.truncatingRemainder(dividingBy: 3_600)) / 60)
                let remainingSeconds = Int(timeComponent.truncatingRemainder(dividingBy: 60))

                return "\(hours):\(abs(minutes)):\(abs(remainingSeconds))"
            }
            else {
                return dueDate.getFormattedDate(format: .slashDate)
            }
        }
        else {
            return ""
        }
    }

    var body: some View {
        VStack {
            ProgressCircle(percent: expense.percentPaidOff,
                           widthHeight: 75,
                           gradient: user.getSettings().getDefaultGradient(),
                           lineWidth: 4,
                           showCheckWhenComplete: false) {
                Text(expense.amountPaidOff.formattedForMoney().replacingOccurrences(of: "$", with: ""))
                    .boldNumber()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding(5)
            }
            Spacer()

            VStack(spacing: 7) {
                Text(expense.titleStr)
                    .font(.caption)
                HStack {
                    Text(expense.amountMoneyStr)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .layoutPriority(1)
                        .foregroundStyle(user.getSettings().getDefaultGradient())

//                    if let dueDate = expense.dueDate,
//                       dueDate > Date.now {
                    Spacer()
                    Text(timeString)
                        .font(.footnote)
                        .layoutPriority(0.5)
//                    }
                }

                .minimumScaleFactor(0.8)
            }
        }
        .padding([.top, .horizontal])
        .padding(.bottom, 10)
        .background(.targetGray, cornerRadius: 10, shadow: 0, padding: 0)
        .onReceive(timer) { _ in
            nowTime = Date.now
        }
    }
}

// MARK: - ExpenseGridBlock_Previews

struct ExpenseGridBlock_Previews: PreviewProvider {
    static let ex = try! Expense(title: "Tesla upgrades",
                                 info: "Fun stuff",
                                 amount: 150,
                                 dueDate: nil,
                                 user: User.main)
    static var previews: some View {
        ExpenseGridBlock(expense: User.main.getExpenses().first!, user: User.main)
            .frame(width: 150, height: 150)
//            .previewLayout(.sizeThatFits)
    }
}
