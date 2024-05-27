//
//  AllocationSummaryView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/7/23.
//

import SwiftUI

// MARK: - ConnectedCirclesView

struct ConnectedCirclesView: View {
    var bottomCircleFill: Color = .primary
    var lineWidth: CGFloat = 3

    var body: some View {
        VStack(spacing: -1) {
            Circle()
                .stroke(lineWidth: lineWidth)

            Image(systemName: "arrow.down").resizable()
            // Vertical line
//            Rectangle()
            ////                .fill(bottomCircleFill)
//                .frame(width: lineWidth) // Adjust the width and height as needed

            // Filled circle
            Circle()
                .fill(bottomCircleFill)
//                .padding(.top, -1)
        }
    }
}

// MARK: - AllocationSummaryView

struct AllocationSummaryView: View {
    // MARK: - Body

    var backgroundColor: Color = UIColor.systemBackground.color
    
    let allocation: Allocation = {
        let user = User.main
        if user.getAllocations().isEmpty {
            user.instantiateExampleItems(context: user.getContext())
        }
        return user.getAllocations().filter{ $0.amount > 1 }.randomElement()!
    }()

    var payoffItem: PayoffItem? {
        if let expense = allocation.expense {
            return expense
        }
        if let goal = allocation.goal {
            return goal
        }
        return nil
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Allocation")
                Spacer()
                Text(allocation.amount.money())
            }
            .fontWeight(.semibold)
            .kerning(0.7)

            HStack {
                HStack(alignment: .top) {
                    ConnectedCirclesView(lineWidth: 2)
                        .frame(width: 12)
                        .padding(.vertical, 4)
                        .frame(maxHeight: .infinity)

                    VStack(alignment: .leading) {
                        Text(allocation.getSourceTitle())
                        Spacer()
//                        Text(allocation.amount.money())
//                        Spacer()
                        if let payoffItem {
                            Text(payoffItem.titleStr)
                        }
                    }
                }
                .frame(height: 60)

                Spacer()

//                Text(allocation.amount.money())
            }
        }
        .modifier(Modifiers(backgroundColor: backgroundColor))
    }

    // MARK: - Modifiers

    struct Modifiers: ViewModifier {
        let backgroundColor: Color
        func body(content: Content) -> some View {
            content
                .padding()
                .background {
                    backgroundColor.clipShape(RoundedRectangle(cornerRadius: 10))
                }
//                .padding()
//                .frame(height: 150)
        }
    }

    // MARK: - Sub Views

    // MARK: - Computed properties

    // MARK: - Helper functions
}

// struct AllocationSummaryView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    let allocationAmount: Double = 123
//    #if DEBUG
//        static let user = User(context: PersistenceController.testing)
//        static let expense = try! Expense(title: "Testing example expense", info: "Ehhh", amount: 12_345, dueDate: .now.addDays(78), dateCreated: .now.addDays(-29), isRecurring: false, recurringDate: nil, tagStrings: nil, repeatFrequency: nil, user: user, context: user.getContext())
//        static let shift = try! Shift(day: .init(date: .now), start: .nineAM, end: .fivePM, user: user, context: user.getContext())
//    #endif
//
//    var body: some View {
//        VStack {
//            HStack(alignment: .lastTextBaseline) {
//                Text("Allocation")
//                    .fontWeight(.medium)
//                    .kerning(0.7)
//                Spacer()
//                Text(allocationAmount.money())
//                    .font(.title3)
//                    .fontWeight(.medium)
//                    .kerning(0.7)
//            }
//
//            VStack(alignment: .leading, spacing: 20) {
//                VStack(alignment: .leading, spacing: 5){
//                    Text("From")
//                        .font(.footnote)
//                    ShiftRow
//                }
//
//                Text("To")
//                    .font(.footnote)
//
//
//
//                //            HStack {
//                //                VStack(spacing: 10) {
//                //                    Text("Shift from 9/23/23")
//                //                        .fontWeight(.semibold)
//                //                    Text("$100")
//                //                    ProgressBar(percentage: 0.2)
//                //                }
//                //
//                //                VStack(spacing: 10) {
//                //                    Text("Expense name")
//                //                        .fontWeight(.semibold)
//                //                    Text("$100 / 234")
//                //                    ProgressBar(percentage: 0.2)
//                //                }
//                //            }
//                //            HStack {
//                //                VStack {
//                //                    Source
//                //
//                //                    Image(systemName: "chevron.down")
//                //                        .resizable()
//                //                        .frame(maxWidth: 40, maxHeight: 10)
//                //                        .fontWeight(.thin)
//                //
//                //                    Source
//                //                }
//                //
//                //                GeometryReader { geo in
//                //                    ZStack(alignment: .bottom) {
//                //                        RoundedRectangle(cornerRadius: 10)
//                //                            .foregroundStyle(UIColor.quaternaryLabel.color)
//                //                        RoundedRectangle(cornerRadius: 10)
//                //                            .foregroundStyle(.blue)
//                //                            .frame(height: max(0, geo.size.height * 0.2))
//                //                    }
//                //                }
//                //                .frame(width: 10)
//                //            }
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background {
//            UIColor.systemBackground.color.clipShape(RoundedRectangle(cornerRadius: 10))
//        }
//        .padding()
//        .frame(maxHeight: 350)
//    }
//
//    var Source: some View {
//        VStack(alignment: .leading) {
//            Text("Source")
//                .fontWeight(.semibold)
//            HStack {
//                Text("Checking Email")
//                Text("9/27/23")
//                    .font(.subheadline)
//                    .foregroundStyle(UIColor.secondaryLabel.color)
//            }
//
//            HStack {
//                Text("$43.22")
//                Text("•")
//                Text("1h 23m")
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//        .padding()
//        .overlay {
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(UIColor.tertiaryLabel.color)
//        }
//    }
//
//    var ShiftRow: some View {
//        HStack {
//            Text(AllocationSummaryView.shift.start.firstLetterOrTwoOfWeekday())
//                .foregroundColor(.white)
//                .frame(width: 35, height: 35)
//                .background(Color.defaultColorOptions.first!.getGradient())
//                .cornerRadius(8)
//
//            VStack(alignment: .leading) {
//                Text(AllocationSummaryView.shift.start.getFormattedDate(format: .abbreviatedMonth))
//                    .font(.subheadline)
//                    .foregroundColor(.primary)
//
//                Text("\(AllocationSummaryView.shift.totalEarned.money())")
//                    .font(.caption2)
//                    .foregroundColor(.secondary)
//            }
//            Spacer()
//
//            VStack {
//                Text("\(allocationAmount.money())/\(AllocationSummaryView.shift.totalEarned.money())")
//                    .font(.subheadline)
//                    .foregroundColor(.primary)
//                    .multilineTextAlignment(.trailing)
//
//                Text("earned")
//                    .font(.caption2)
//                    .foregroundStyle(UIColor.secondaryLabel.color)
//                    .multilineTextAlignment(.trailing)
//            }
//        }
//    }
//
//    var Copying: some View {
//        VStack {
//            Text("Allocation")
//                .fontWeight(.medium)
//                .kerning(0.7)
//            VStack(alignment: .leading) {
//                HStack {
//                    Text("$500")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                    HStack {
//                        Text("/")
//                        Text("1200")
//                    }
//                    .foregroundStyle(UIColor.secondaryLabel.color)
//                }
//
//                VStack(alignment: .leading, spacing: 20) {
//                    ProgressBar(percentage: 0.4, height: 5)
//
//                    HStack(spacing: 30) {
//                        VStack(alignment: .leading) {
//                            Text("Money left")
//                                .font(.subheadline)
//                                .foregroundStyle(UIColor.secondaryLabel.color)
//                                .fontWeight(.semibold)
//                            Text("$700")
//                        }
//                        VStack(alignment: .leading) {
//                            Text("Days left")
//                                .font(.subheadline)
//                                .foregroundStyle(UIColor.secondaryLabel.color)
//                                .fontWeight(.semibold)
//                            Text("20 days left")
//                        }
//                    }
//                }
//            }
//
//            VStack(alignment: .leading, spacing: 10) {
//                Image(systemName: "lightbulb")
//
//                (Text("Close goal faster! ").bold() +
//                    Text("We estimated your payment for each week to complete goal sooner"))
//                    .lineLimit(10)
//                    .font(.subheadline)
//
//                Divider()
//
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text("Weeks in your plan")
//                            .font(.subheadline)
//                            .fontWeight(.medium)
//                            .foregroundStyle(.gray)
//                        Text("2")
//                    }
//
//                    Spacer()
//
//                    Text("$600.00/week")
//                }
//            }
//            .padding()
//
//            .overlay {
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(.gray)
//            }
//        }
//    }
// }

#Preview {
    ZStack {
        UIColor.secondarySystemBackground.color.frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea()
        AllocationSummaryView()
    }
    .environment(\.managedObjectContext, PersistenceController.testing)
}
