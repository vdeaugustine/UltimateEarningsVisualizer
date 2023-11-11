//
//  TodayViewInfoRect.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/19/23.
//

import SwiftUI

// MARK: - TodayViewInfoRect

struct TodayViewInfoRect: View {
    let imageName: String
    let valueString: String
    let bottomLabel: String

    let isPayOffItem: Bool
    let circleColor: Color

    /// Defaults to 124
    var height: CGFloat?
    /// Defaults to title2
    var titleFont: Font?
    /// Defaults to headline
    var subtitleFont: Font?
    /// Defaults to system size 28
    var imageFont: CGFloat?

    init(imageName: String, valueString: String, bottomLabel: String, isPayOffItem: Bool = false, circleColor: Color = .white, height: CGFloat? = nil, titleFont: Font? = nil, subtitleFont: Font? = nil, imageFontSize: CGFloat? = nil) {
        self.imageName = imageName
        self.valueString = valueString
        self.bottomLabel = bottomLabel
        self.isPayOffItem = isPayOffItem
        self.circleColor = circleColor
        self.height = height
        self.titleFont = titleFont
        self.subtitleFont = subtitleFont
        self.imageFont = imageFontSize
    }

    init(imageName: String, valueString: String, bottomLabel: String, height: CGFloat = 124) {
        self.imageName = imageName
        self.valueString = valueString
        self.bottomLabel = bottomLabel
        self.isPayOffItem = false
        self.circleColor = .white
        self.height = height
    }

    init(circleColor: Color, valueString: String, bottomLabel: String, height: CGFloat = 124) {
        self.valueString = valueString
        self.bottomLabel = bottomLabel
        self.imageName = ""
        self.isPayOffItem = true
        self.circleColor = circleColor
        self.height = height
    }

    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading) {
                if isPayOffItem {
                    Circle()
                        .fill(circleColor)
                        .frame(height: imageFont ?? 20)
                        .padding(.bottom, 2)
//                        .padding(.top)

                } else {
                    Image(systemName: imageName)
                        .font(.system(size: imageFont ?? 28))
//                        .padding(.top)
                }

                Spacer()
//                    .frame(maxHeight: 2)

                VStack(alignment: .leading, spacing: 0) {
                    Text(valueString)
                        .font(titleFont ?? .title2)
                        .fontWeight(.semibold)
//                        .lineLimit(1)
                    Text(bottomLabel)
                        .font(subtitleFont ?? .headline)
                        .fontWeight(.regular)
                        .lineLimit(1)
                        .foregroundStyle(Color(hex: "868686"))
                }
//                .padding(.bottom)
            }
            .padding(.leading, 16)
            .frame(alignment: .bottomLeading)
            .padding(.vertical)
        }
        .frame(height: height ?? 124)
        .frame(maxWidth: 181, alignment: .leading)
        .background {
            UIColor.systemBackground.color
        }
        .cornerRadius(20)
//        .modifier(ShadowForRect())
    }
}

// MARK: - TodayViewInfoRect_Previews

struct TodayViewInfoRect_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.targetGray
            TodayViewInfoRect(imageName: "hourglass",
                              valueString: "08:14:32",
                              bottomLabel: "Remaining")
        }
        .environmentObject(TodayViewModel.main)
    }
}
