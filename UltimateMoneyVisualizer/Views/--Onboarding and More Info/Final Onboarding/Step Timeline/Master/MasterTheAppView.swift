//
//  MasterTheAppView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/26/23.
//

import ConfettiSwiftUI
import SwiftUI



// MARK: - MasterTheAppViewModel

class MasterTheAppViewModel: ObservableObject {
    
    @Published var viewStack: NavigationPath = .init()
    @Published var level: Int = 0
    
    static var shared: MasterTheAppViewModel = .init()

    func continueTapped() {
        switch level {
            case 0:
                navigateToSetup()
            case 1:
                navigateToSchedule()
            case 2:
                finish()
            default:
                return
        }
    }
    
    func finish() {
        print("Finished")
        level = 2
//        level =
    }

    func navigateToSetup() {
        viewStack.append(Views.wageWalkthrough)
    }
    
    func navigateToSchedule() {
        viewStack.append(Views.scheduleWalkthrough)
    }

    enum Views: Hashable {
        case wageWalkthrough
        case scheduleWalkthrough
    }

    @ViewBuilder func getDestination(for view: Views) -> some View {
        switch view {
            case .wageWalkthrough:
                FinalOnboardingWageWalkThrough()
            case .scheduleWalkthrough:
                FinalOnboardingScheduleFullSheet()
        }
    }
}

// MARK: - MasterTheAppView

struct MasterTheAppView: View {
    let circlesGreenColor = Color(hex: "B1E7CF")
    let grayColor = Color(hex: "DEDEDE")
    let finishedTitleColor = Color(hex: "3BDA92")
    let unfinishedTitleColor = Color(hex: "233D5F")
    let finishedIconGreen = Color(hex: "2D9350")

    @State private var showConfetti: Int = 0

    @StateObject var viewModel = MasterTheAppViewModel.shared

    var body: some View {
        GeometryReader { geo in
            NavigationStack(path: $viewModel.viewStack) {
                VStack {
                    Text("Setting Things Up")
                        .font(.system(size: 30, weight: .bold, design: .rounded))

                    timelineRows
                        .conditionalModifier(geo.frame(in: .global).size.height < 750) { view in
                            view
                                .putInScrollView(indicatorVisibility: .hidden)
                        }

                    Spacer()

                    FinalOnboardingButton(title: "Continue") {
                        viewModel.continueTapped()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    OnboardingBackground()
                }
                .onAppear(perform: {
                    print(geo.frame(in: .global).size.height)
                })
                
                .navigationDestination(for: MasterTheAppViewModel.Views.self) { view in
                    viewModel.getDestination(for: view).toolbar(.hidden, for: .navigationBar)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .environmentObject(viewModel)
    }
}

// MARK: - Time Line Text Rows

extension MasterTheAppView {
    var timelineRows: some View {
        VStack(spacing: -1) {
            TimelineRow(title: "Earnings",
                        subtitle: "Set up your earnings info to let the app work for you.",
                        isDone: viewModel.level > 0,
                        isActive: viewModel.level == 0,
                        iconName: "dollarsign",
                        lineUp: nil,
                        lineDown: viewModel.level >= 0 ? circlesGreenColor : grayColor)

            TimelineRow(title: "Schedule",
                        subtitle: "Set your work schedule so the app can automatically generate your shifts, allowing you to track your earnings easier.",
                        isDone: viewModel.level > 1,
                        isActive: viewModel.level == 1,
                        iconName: "book",
                        lineUp: viewModel.level > 0 ? circlesGreenColor : grayColor,
                        lineDown: viewModel.level > 0 ? circlesGreenColor : grayColor)

//            TimelineRow(title: "Use earnings to payoff items",
//                        subtitle: "Learn how to use the Allocation feature to assign specific money you earn towards specific expenses or goals.",
//                        isDone: viewModel.level > 2,
//                        isActive: viewModel.level == 2,
//                        iconName: "arrow.left.arrow.right",
//                        lineUp: viewModel.level > 1 ? circlesGreenColor : grayColor,
//                        lineDown: viewModel.level > 1 ? circlesGreenColor : grayColor)
//
//            TimelineRow(title: "Itemize your shifts",
//                        subtitle: "Learn to use the Time Blocks feature to break your shifts into different tasks and see how much you’re getting paid to email.",
//                        isDone: viewModel.level > 3,
//                        isActive: viewModel.level == 3,
//                        iconName: "slider.horizontal.below.square.filled.and.square",
//                        lineUp: viewModel.level > 2 ? circlesGreenColor : grayColor,
//                        lineDown: viewModel.level > 2 ? circlesGreenColor : grayColor)
            TimelineRow(title: "Complete",
                        subtitle: "You're all set! Time to master your money!",
                        isDone: viewModel.level > 3,
                        isActive: viewModel.level == 2,
                        iconName: "trophy",
                        isSystemIcon: true,
                        lineUp: viewModel.level > 1 ? circlesGreenColor : grayColor,
                        lineDown: nil)
        }
        .scrollIndicators(.hidden)

//        }
    }
}

extension MasterTheAppView {
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

    @ViewBuilder func Icon(name: String,
                           isSystemIcon: Bool = true,
                           isDone: Bool,
                           isActive: Bool,
                           lineUp: Color?,
                           lineDown: Color?,
                           rectangleHeight: CGFloat = 40)
        -> some View {
        let mainCircleColor: Color = isDone || isActive ? circlesGreenColor : grayColor
        let iconForegroundColor: Color = isDone ? finishedIconGreen : unfinishedTitleColor

        VStack(spacing: 0) {
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

                if isDone {
                    Image(systemName: "checkmark")
                        .foregroundStyle(iconForegroundColor)
                        .fontWeight(.semibold)
                } else {
                    if isSystemIcon {
                        Image(systemName: name)
                            .foregroundStyle(iconForegroundColor)
                            .fontWeight(.semibold)
                    } else {
                        Image(name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(iconForegroundColor)
                            .fontWeight(.semibold)
                    }
                }
            }
            .frame(width: 60)
            .shadow(radius: 20)

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
                     isSystemIcon: Bool = true,
                     lineUp: Color? = nil,
                     lineDown: Color? = nil)
        -> some View {
        HStack {
            // Icon and rect
            Icon(name: iconName,
                 isSystemIcon: isSystemIcon,
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
                    .animation(.smooth, value: isDone)

                Text(subtitle)
                    .font(
                        .system(size: 16,
                                weight: .medium,
                                design: .rounded)
                    )
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
//            .shadow(radius: 14)
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
