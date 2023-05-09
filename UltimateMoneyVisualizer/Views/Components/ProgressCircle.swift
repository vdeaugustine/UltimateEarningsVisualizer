//
//  ProgressCircle.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/28/23.
//

import SwiftUI

// MARK: - ProgressCircle

struct ProgressCircle<Content: View>: View {
    var percent: Double
    var widthHeight: CGFloat = 33
    var lineWidth: CGFloat = 2
    let showCheckWhenComplete: Bool
    let content: () -> Content
    @ObservedObject var settings = User.main.getSettings()

    init(percent: Double, widthHeight: CGFloat = 33, lineWidth: CGFloat = 2, showCheck: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.percent = percent
        self.widthHeight = widthHeight
        self.lineWidth = lineWidth
        self.showCheckWhenComplete = showCheck
        self.content = content
    }

    var body: some View {
        ZStack {
            if percent >= 1,
               showCheckWhenComplete {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.green)
                    .frame(width: widthHeight - 10, height: widthHeight - 10)
            } else {
                ZStack {
                    Circle()
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(.gray)
                    Circle()
                        .trim(from: .leastNonzeroMagnitude, to: percent > 0.05 ? percent : 0.05)
                        .stroke(lineWidth: lineWidth)
                        .rotationEffect(.degrees(-90))
                        .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
                        .foregroundStyle(settings.getDefaultGradient())
                    content()
                        .padding(.horizontal, 2)
                }
                .frame(width: widthHeight - 10, height: widthHeight - 10)
            }
        }

        .frame(width: widthHeight, height: widthHeight)
    }
}

// MARK: - ProgressCircle_Previews

// struct ProgressCircle: View {
//    var percent: Double
//    var widthHeight: CGFloat = 33
//    var textToShowInMiddle: String? = nil
//    var lineWidth: CGFloat = 2
//    var body: some View {
//        ZStack {
//            if percent >= 1 {
//                Image(systemName: "checkmark.circle")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .foregroundColor(.green)
//                    .frame(width: widthHeight - 10, height: widthHeight - 10)
//            } else {
//                ZStack {
//                    Circle()
//                        .stroke(lineWidth: lineWidth)
//                        .foregroundColor(.gray)
//                    Circle()
//                        .trim(from: .leastNonzeroMagnitude, to: percent > 0.05 ? percent : 0.05)
//                        .stroke(lineWidth: lineWidth)
//                        .rotationEffect(.degrees(-90))
//                        .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
//                        .foregroundColor(UserDefaults.themeColor)
//                    if let textToShowInMiddle = textToShowInMiddle {
//                        Text(textToShowInMiddle)
//                            .minimumScaleFactor(0.2)
//                            .padding(.horizontal, 2)
//                    }
//                }
//                .frame(width: widthHeight - 10, height: widthHeight - 10)
//            }
//        }
//
//        .frame(width: widthHeight, height: widthHeight)
//    }
// }

struct ProgressCircle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCircle(percent: 1, widthHeight: 330, lineWidth: 2) {
            Text("50%")
                .minimumScaleFactor(0.2)
        }
        .previewLayout(.sizeThatFits)
    }
}
