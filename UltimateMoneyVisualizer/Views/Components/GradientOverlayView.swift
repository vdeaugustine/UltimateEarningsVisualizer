//
//  GradientOverlayView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 5/19/23.
//

import SwiftUI

// MARK: - GradientOverlayView

struct GradientOverlayView: View {
    let image: Image?
    var maxHeight: CGFloat = 150

    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                Color.okGreen
            }
        }

        .overlay(
            ZStack {
                LinearGradient(gradient: Gradient(stops: [.init(color: Color.black.opacity(0.8), location: 0.1),
                                                          .init(color: Color.black.opacity(0.7), location: 0.25),
                                                          .init(color: Color.black.opacity(0.1), location: 1)]),
                startPoint: .bottom,
                endPoint: .top)

                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(alignment: .bottom) {
                                Text("Goal title")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                                Text("$750 / $1000")
                                    .font(.caption2)
                            }

                            ProgressBar(percentage: 0.75, height: 3)

                            HStack {
                                Text("May 10, 2023")

                                Spacer()
                                Text("75%")
                            }
                            .font(.caption2)
                        }
                        .foregroundColor(Color.white)
                        Spacer()
                    }
                }
                .padding(4)
            }
        )
        .frame(maxHeight: maxHeight)
    }
}

// MARK: - GradientOverlayView_Previews

struct GradientOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        GradientOverlayView(image: Image("disneyworld"))
    }
}
