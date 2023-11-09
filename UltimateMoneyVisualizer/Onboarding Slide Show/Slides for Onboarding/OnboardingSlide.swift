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
    
    init(title: String, imageString: String, header: String, bodyTexts: [String]) {
        self.title = title
        self.imageString = imageString
        self.header = header
        self.bodyTexts = bodyTexts
    }
    
    init(slide: OnboardingSlideShow.Slide) {
        self.title = slide.title
        self.imageString = slide.imageString
        self.header = slide.header
        self.bodyTexts = slide.bodyTexts
    }
    
//    Text("Watch your money grow in real-time as you earn it")
//        .layoutPriority(2)
//    Text("Look back on previous shifts to see how much you made each day")
//        .layoutPriority(2)
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .kerning(1)
            
            Image(imageString)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 200)
                .layoutPriority(0)
                .background {
                    GeometryReader { geo in
                        Color.clear.onAppear(perform: {
                            print("Image height: ", geo.size.height)
                        })
                    }
                }
            
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
            .layoutPriority(1)
        }
        .padding()
        .background {
            GeometryReader { geo in
                Color(hex: "FDFDFD")
                    .onAppear {
                        print("Height of card is: ", geo.size.height)
                    }
            }
                
        }
        
        
    }
}

//Text("Watch your money grow in real-time as you earn it")
//        .layoutPriority(2)
//    Text("Look back on previous shifts to see how much you made each day")
//        .layoutPriority(2)
#Preview {
    OnboardingSlide(title: "Shifts", imageString: "timeToMoney", header: "Track your earnings", bodyTexts: ["Watch your money grow in real-time as you earn it", "Look back on previous shifts to see how much you made each day"])
}
