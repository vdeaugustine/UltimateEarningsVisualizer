//
//  FigmaDesign.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/13/23.
//

import SwiftUI
import Vin

// MARK: - ScrollReaderTesting

struct ScrollReaderTesting: View {
    @State private var offset: CGFloat = 0

    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                Color.clear.preference(key: ViewOffsetKey.self, value: geometry.frame(in: .named("scrollView")).minY)
            }
            .frame(height: 0)

            ForEach(1 ... 100, id: \.self) { _ in
                Text("Item")
                    .padding()
                    .background(Color.gray.opacity(0.1))
            }
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(ViewOffsetKey.self) { offset in
            self.offset = offset
        }
        .overlay(
            Group {
                if offset < -200 {
                    ZStack {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 100, height: 100)
                        Text("\(Int(offset))")
                            .foregroundColor(.white)
                    }
                }
            }
        )
    }
}

// MARK: - ViewOffsetKey

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - ScrollReaderTesting_Previews

struct ScrollReaderTesting_Previews: PreviewProvider {
    static var previews: some View {
        ScrollReaderTesting()
    }
}
