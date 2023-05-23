//
//  ProgressBar.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 4/28/23.
//

import SwiftUI

// MARK: - ProgressBar

struct ProgressBar: View {
    let percentage: Double
    let cornerRadius: CGFloat = 25
    var height: CGFloat = 8
    var color: Color = .accentColor

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
        let entireBarWidth = width
        return ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(.gray)
                .frame(width: entireBarWidth)
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundStyle(isComplete ? Color.okGreen.getGradient() : color.getGradient())
//                .foregroundColor(isComplete ? .green : color)
                .frame(width: percentageToUse * entireBarWidth)
        }
        .frame(height: height)
    }

    var body: some View {
        GeometryReader { geo in
            barPart(width: geo.size.width)
        }
        .frame(height: height)
    }

    struct Preview: View {
        @State var percentage: Double
        let increaseAmount: Double
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

        var body: some View {
            ProgressBar(percentage: percentage)
                .onReceive(timer) { _ in
                    percentage += increaseAmount
                }
        }
    }
}

// MARK: - ProgressBar_Previews

struct ProgressBar_Previews: PreviewProvider {
    static var prog: Double = 0.0

    static var previews: some View {
        ProgressBar.Preview(percentage: 0.0, increaseAmount: 0.1)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
