//
//  FinalOnboardingTitleAndSubtitle.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 12/1/23.
//

import SwiftUI

struct FinalOnboardingTitleAndSubtitle: View {
    let title: String
    let subtitle: String

    let geo: GeometryProxy

    @EnvironmentObject private var viewModel: FinalWageViewModel

    func widthScaler(_ width: CGFloat, geo: GeometryProxy) -> CGFloat {
        let frameWidth = geo.size.width
        let coefficient = frameWidth / 393
        return coefficient * width
    }

    func heightScaler(_ height: CGFloat, geo: GeometryProxy) -> CGFloat {
        let frameHeight = geo.size.height
        let coefficient = frameHeight / 852
        return coefficient * height
    }

    var body: some View {
        VStack(alignment: .leading, spacing: heightScaler(30, geo: geo)) {
            Text(title)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, widthScaler(96, geo: geo))

            if subtitle.isEmpty == false {
                Text(subtitle)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    GeometryReader{ geo in
        FinalOnboardingTitleAndSubtitle(title: "Salary Calculation Assumptions", subtitle: "This allows you to see your earnings breakdown by hour, minute, second, etc.", geo: geo)
    }
}
