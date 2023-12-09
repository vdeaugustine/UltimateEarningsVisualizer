//
//  AllocationSummaryView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/7/23.
//

import SwiftUI

// MARK: - ConnectedCirclesView

struct ConnectedCirclesView: View {
    var bottomCircleFill: Color = .black
    var lineWidth: CGFloat = 3

    var body: some View {
        VStack(spacing: -1) {
            Circle()
                .stroke(lineWidth: lineWidth)

            Image(systemName: "arrow.down").resizable()
            // Vertical line

            // Filled circle
            Circle()
                .fill(bottomCircleFill)
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
                        if let payoffItem {
                            Text(payoffItem.titleStr)
                        }
                    }
                }
                .frame(height: 60)

                Spacer()
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
        }
    }

}

#Preview {
    ZStack {
        UIColor.secondarySystemBackground.color.frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea()
        AllocationSummaryView()
    }
    .environment(\.managedObjectContext, PersistenceController.testing)
}
