//
//  ShiftSlide.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 11/8/23.
//

import SwiftUI

struct OnboardingSlide: View {
//    @Binding var height: CGFloat

    let title: String
    let imageString: String
    let header: String
    let bodyTexts: [String]
    let action: () -> Void

    init(title: String, imageString: String, header: String, bodyTexts: [String], _ action: @escaping () -> Void) {
        self.title = title
        self.imageString = imageString
        self.header = header
        self.bodyTexts = bodyTexts
        self.action = action
    }

    init(slide: OnboardingSlideShow.Slide, _ action: @escaping () -> Void) {
        self.title = slide.title
        self.imageString = slide.imageString
        self.header = slide.header
        self.bodyTexts = slide.bodyTexts
        self.action = action
    }

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .kerning(1)
//                .padding(.top)

            Image(imageString)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 200)
                .layoutPriority(0)
            
//                .background {
//                    GeometryReader { geo in
//                        Color.clear.onAppear(perform: {
//                            print("Image height: ", geo.size.height)
//                        })
//                    }
//                }

            VStack(spacing: 20) {
                Text(header)
                    .font(.system(.title3, weight: .semibold))
                    .kerning(1)

                VStack(alignment: .leading, spacing: 15) {
                    ForEach(bodyTexts, id: \.self) { text in
                        Text(text)
                            .layoutPriority(2)
                    }
                }
                .font(.system(.subheadline, weight: .medium))
                .foregroundStyle(.secondary)
                .kerning(0.5)
            }
            .padding(.top)
            .layoutPriority(1)
            .foregroundStyle(.tint)
//            Button("Learn More") {
//                action()
//            }
//            .padding(.top, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background {
            GeometryReader { geo in
                Color(hex: "FDFDFD")
                    .onAppear {
                        print("Height of card is: ", geo.size.height)
                    }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .modifier(ShadowForRect())
    }
}

// Text("Watch your money grow in real-time as you earn it")
//        .layoutPriority(2)
//    Text("Look back on previous shifts to see how much you made each day")
//        .layoutPriority(2)
#Preview {
    ZStack {
        UIColor.secondarySystemBackground.color
        OnboardingSlide(title: "Shifts", imageString: "timeToMoney", header: "Track your earnings", bodyTexts: ["Watch your money grow in real-time as you earn it", "Look back on previous shifts to see how much you made each day"]) {}
            .padding(20)
    }
}
