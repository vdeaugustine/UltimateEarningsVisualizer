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
    let gradient: LinearGradient
    var lineWidth: CGFloat = 2
    let showCheckWhenComplete: Bool
    @ViewBuilder let content: () -> Content
    @ObservedObject var settings = User.main.getSettings()

    internal init(percent: Double,
                  widthHeight: CGFloat = 33,
                  gradient: LinearGradient,
                  lineWidth: CGFloat = 2,
                  showCheckWhenComplete: Bool = false,
                  content: @escaping () -> Content,
                  settings: Settings = User.main.getSettings()) {
        self.percent = percent
        self.widthHeight = widthHeight
        self.gradient = gradient
        self.lineWidth = lineWidth
        self.showCheckWhenComplete = showCheckWhenComplete
        self.content = content
        self.settings = settings
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
                        .foregroundStyle(gradient)
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
        ProgressCircle(percent: 1,
                       widthHeight: 330,
                       gradient: User.main.getSettings().getDefaultGradient(),
                       lineWidth: 2) {
            Text("50%")
                .minimumScaleFactor(0.2)
        }
        .previewLayout(.sizeThatFits)
    }
}
