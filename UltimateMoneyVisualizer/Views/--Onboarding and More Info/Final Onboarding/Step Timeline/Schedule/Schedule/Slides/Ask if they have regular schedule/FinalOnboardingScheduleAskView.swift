//
//  FinalOnboardingScheduleAskView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/2/23.
//

import SwiftUI

struct FinalOnboardingScheduleAskView: View {
    @EnvironmentObject private var viewModel: FinalOnboardingScheduleViewModel

    enum YesOrNo: String, Hashable, Equatable, CaseIterable {
        case yes
        case no
        
        var boolValue: Bool {
            switch self {
                case .yes:
                    return true
                case .no:
                    return false
            }
        }
    }

    var bottomButtonLabel: String {
        return "Continue"
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 30) {
                TitleAndContent(geo: geo)

                Spacer()

            }
            .padding(.horizontal, widthScaler(24, geo: geo))
        }
    }

    @ViewBuilder func optionRow(option: YesOrNo) -> some View {
        Text(option.rawValue.capitalized)
            .font(.system(.headline, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background {
                UIColor.systemBackground.color
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(0.35)
                    .conditionalModifier(viewModel.userHasRegularSchedule == option.boolValue) { thisView in
                        thisView
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.accentColor, lineWidth: 2)
                            }
                    }
            }
            .onTapGesture {
                withAnimation {
                    if option == .no {
                        viewModel.userHasRegularSchedule = false
                    }
                    else {
                        viewModel.userHasRegularSchedule = true
                    }
                }
            }
    }

    @ViewBuilder func TitleAndContent(geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: heightScaler(40, geo: geo)) {
            Text("Do you have a regular schedule?")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, widthScaler(96, geo: geo))

            VStack(alignment: .leading) {
                ForEach(YesOrNo.allCases, id: \.self) { option in
                    optionRow(option: option)
                }
            }
            
            VStack(alignment: .leading, spacing: 20) {
                Text("If your scheduled hours are not consistent every week, that's ok!")
                Text("You can still enter your shifts manually")
            }
            .font(.system(size: 20, weight: .regular, design: .rounded))
            .foregroundStyle(.secondary)
            .padding(.top, 30)
        }
    }

    @ViewBuilder var ContinueButton: some View {
        FinalOnboardingButton(title: bottomButtonLabel) {
            if viewModel.slideNumber < viewModel.totalSlideCount {
                viewModel.slideNumber += 1
            }
        }
    }
}

#Preview {
    FinalOnboardingScheduleAskView()
        .environmentObject(FinalOnboardingScheduleViewModel.testing)
}
