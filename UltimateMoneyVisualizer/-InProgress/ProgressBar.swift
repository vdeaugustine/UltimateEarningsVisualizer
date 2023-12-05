//
//  ProgressBar.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/28/23.
//

import SwiftUI

// MARK: - ProgressBar

struct ProgressBar: View {
    // CATEGORY: Internal

    let percentage: Double
    let cornerRadius: CGFloat = 25
    var height: CGFloat = 8
    var color: Color = .accentColor
    var completeColor: Color = Color.okGreen
    var barBackgroundColor: Color = Color(uiColor: .lightGray)
    var showBackgroundBar = true

    var body: some View {
        GeometryReader { geo in
            barPart(width: geo.size.width)
        }
        .frame(height: height)
    }

    // CATEGORY: Private

    private var isComplete: Bool {
        percentage >= 1
    }

    private var percentageToUse: Double {
        if percentage < 0 { return 0 }
        if percentage > 1 { return 1 }
        if percentage == 0 { return 0.01 }
        return percentage
    }

    private func barPart(width: CGFloat) -> some View {
        ZStack(alignment: .leading) {
            if showBackgroundBar {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(barBackgroundColor)
                    .frame(width: width)
            }
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundStyle(isComplete ?  completeColor.getGradient() : color.getGradient(brightnessConstant: 20))
                .frame(width: max(0, percentageToUse * width))
        }
        .frame(height: height)
    }
}

extension ProgressBar {
    struct Preview: View {
        @State var percentage: Double
        let increaseAmount: Double
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

        var body: some View {
            ProgressBar(percentage: percentage, height: 60, color: User.main.getSettings().themeColor)
                .onReceive(timer) { _ in
                    withAnimation{
                        percentage += increaseAmount
                    }
                }
        }
    }
}

// MARK: - ProgressBar_Previews

struct ProgressBar_Previews: PreviewProvider {
    static var prog: Double = 0.0

    static var previews: some View {
        ZStack {
            Color.targetGray
            ProgressBar.Preview(percentage: 0.0, increaseAmount: 0.1)
                .padding()
                .previewLayout(.sizeThatFits)
                .background {
                    Color.white
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 4, y: 4)
                }
        }
    }
}
