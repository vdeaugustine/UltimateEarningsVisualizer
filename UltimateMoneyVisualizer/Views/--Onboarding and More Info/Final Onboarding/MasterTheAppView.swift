//
//  MasterTheAppView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/26/23.
//

import SwiftUI

// MARK: - MasterTheAppView

struct MasterTheAppView: View {
    let circlesGreenColor = Color(hex: "B1E7CF")
    let grayColor = Color(hex: "DEDEDE")
    let finishedTitleColor = Color(hex: "3BDA92")
    let unfinishedTitleColor = Color(hex: "233D5F")
    let finishedIconGreen = Color(hex: "2D9350")
    
    @State private var level: Int = 1

    var body: some View {
        VStack {
            Text("Master the app")
                .font(.system(size: 30, weight: .bold, design: .rounded))

            timelineRows

            Spacer()

            OnboardingButton(title: "Continue") {
                withAnimation {
                    level += 1
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            OnboardingBackground()
        }
    }
}

// MARK: - Time Line Text Rows

extension MasterTheAppView {
    var timelineRows: some View {
        VStack(spacing: -1) {
            TimelineRow(title: "Set up for you",
                        subtitle: "You successfully set up your earnings info to let the app work for you.",
                        isDone: level > 0,
                        iconName: "checkmark",
                        lineUp: nil,
                        lineDown: circlesGreenColor)

            TimelineRow(title: "Learn to track your spending",
                        subtitle: "Learn to create expenses and goals to track money as it goes out.",
                        isDone: level > 1,
                        isActive: level == 1,
                        iconName: "book",
                        lineUp: circlesGreenColor,
                        lineDown: level > 0 ? circlesGreenColor : grayColor)
            
            TimelineRow(title: "Use earnings to payoff items",
                        subtitle: "Learn how to use the Allocation feature to assign specific money you earn towards specific expenses or goals.",
                        isDone: level > 2,
                        isActive: level == 2,
                        iconName: "arrow.left.arrow.right",
                        lineUp: level > 1 ? circlesGreenColor : grayColor,
                        lineDown: level > 1 ? circlesGreenColor : grayColor)
            
            TimelineRow(title: "Itemize your shifts",
                        subtitle: "Learn to use the Time Blocks feature to break your shifts into different tasks and see how much you’re getting paid to email.",
                        isDone: level > 3,
                        isActive: level == 3,
                        iconName: "slider.horizontal.below.square.filled.and.square",
                        lineUp: level > 2 ? circlesGreenColor : grayColor,
                        lineDown: nil)
        }
    }
}

extension MasterTheAppView {
    var timelineIconsAndLines: some View {
        VStack(spacing: -2) {
            Icon(name: "checkmark",
                 isDone: true,
                 isActive: false,
                 lineUp: nil,
                 lineDown: circlesGreenColor)
            Rectangle()
                .fill(Color(hex: "B1E7CF"))
                .frame(width: 8, height: 60)
        }
    }

    var checkmarkIcon: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color(hex: "B1E7CF"))
                    .frame(width: 40)

                Image(systemName: "checkmark")
                    .foregroundStyle(Color(hex: "2D9350"))
                    .fontWeight(.bold)
            }
        }
    }

    func Icon(name: String,
              isDone: Bool,
              isActive: Bool,
              lineUp: Color?,
              lineDown: Color?,
              rectangleHeight: CGFloat = 40)
        -> some View {
        let mainCircleColor: Color = isDone || isActive ? circlesGreenColor : grayColor
        let iconForegroundColor: Color = isDone ? finishedIconGreen : unfinishedTitleColor

        return VStack(spacing: 0) {
            if let lineUp = lineUp {
                Rectangle()
                    .fill(lineUp)
                    .frame(width: 8, height: rectangleHeight)
            } else {
                Spacer()
                    .frame(height: rectangleHeight)
            }

            ZStack {
                Circle()
                    .fill(mainCircleColor)
                    .frame(width: rectangleHeight)

                if isActive {
                    Circle()
                        .fill(circlesGreenColor)
                        .opacity(0.5)
                        .frame(width: 55)
                }

                Image(systemName: name)
                    .foregroundStyle(iconForegroundColor)
                    .fontWeight(.semibold)
            }
            .frame(width: 60)

            if let lineDown = lineDown {
                Rectangle()
                    .fill(lineDown)
                    .frame(width: 8, height: rectangleHeight)
            } else {
                Spacer()
                    .frame(height: rectangleHeight)
            }
        }
    }
}

extension MasterTheAppView {
    func TimelineRow(title: String,
                     subtitle: String,
                     isDone: Bool,
                     isActive: Bool = false,
                     iconName: String,
                     lineUp: Color? = nil,
                     lineDown: Color? = nil)
        -> some View {
        HStack {
            // Icon and rect
            Icon(name: iconName,
                 isDone: isDone,
                 isActive: isActive,
                 lineUp: lineUp,
                 lineDown: lineDown)

            // Text
            VStack(alignment: .leading) {
                Text(title)
                    .font(
                        .system(size: 20,
                                weight: .semibold,
                                design: .rounded)
                    )

                    .foregroundStyle(isDone ? finishedTitleColor : unfinishedTitleColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .strikethrough(isDone)
                Text(subtitle)
                    .font(
                        .system(size: 16,
                                weight: .medium,
                                design: .rounded)
                    )
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

extension MasterTheAppView {
    enum Status {
        case active, upcoming, done
    }
}

#Preview {
    MasterTheAppView()
}
