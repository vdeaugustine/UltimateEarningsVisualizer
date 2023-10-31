//
//  FontTester.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 10/18/23.
//
import SwiftUI

extension Font {
    static let builtInOrder: [Font] = [.largeTitle,
                                       .title,
                                       .title2,
                                       .title3,
                                       .headline,
                                       .body,
                                       .callout,
                                       .subheadline,
                                       .footnote,
                                       .caption,
                                       .caption2]

    static let titlesOfBuiltIn: [String] = ["Large Title",
                                            "Title",
                                            "Title 2",
                                            "Title 3",
                                            "Headline",
                                            "Body",
                                            "Callout",
                                            "Subheadline",
                                            "Footnote",
                                            "Caption",
                                            "Caption 2"]
    var description: String {
        if let fontIndex = Font.builtInOrder.firstIndex(of: self),
           let string = Font.titlesOfBuiltIn.safeGet(at: fontIndex) {
            return string
        }
        return "Not built in"
    }
}

#if DEBUG

   

    struct FontTester: View {
        var body: some View {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(Font.builtInOrder, id: \.self) { font in

                        Text(font.description).font(font)
                    }
                }
                .padding()

                HStack(spacing: 0) {
                    Text("The difference between")
                        .font(.callout)
                    Text(" callout(first) and body")
                }
                .padding()

//            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    Text("Difference between")
                        .font(.subheadline)
                    Text(" subheadline and callout")
                        .font(.callout)

//                }
                }
            }
        }
    }

    #Preview {
        FontTester()
    }

#endif
