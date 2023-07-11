//
//  GoalDetailTagsSection.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/11/23.
//

import SwiftUI
import Vin

// MARK: - GoalDetailTagsSection

struct GoalDetailTagsSection: View {
    @ObservedObject var viewModel: GoalDetailViewModel

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        header
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.goal.getTags()) { tag in
                                    NavigationLink {
                                        TagDetailView(tag: tag)

                                    } label: {
                                        Text(tag.title ?? "NA")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .padding(.trailing, 10)
                                            .background {
                                                PriceTag(height: 30, color: tag.getColor(), holePunchColor: .listBackgroundColor)
                                            }
                                    }
                                }
                            }
                        }
                    }
                    VStack {
                        largePriceTag
                    }.frame(maxHeight: .infinity)
                }
            }
        }
        .padding()
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 0.2)
                .overlay {
                    backDrop
                }
        }
    }

    var backDrop: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        }
    }

    var header: some View {
        VStack {
            Text("Tags")
                .font(.title)
                .fontWeight(.semibold)
        }
    }

    var largePriceTag: some View {
        PriceTag(width: 75,
                 height: 50,
                 color: viewModel.user.getSettings().themeColor,
                 holePunchColor: .white,
                 rotation: 200)
            .padding(.trailing, 10)
    }
    
    struct RoundedRectangleWithSemicircle: Shape {
        let cornerRadius: CGFloat
        let semicircleRadius: CGFloat

        func path(in rect: CGRect) -> Path {
            let width = rect.width
            let height = rect.height

            let path = Path { path in
                path.move(to: CGPoint(x: cornerRadius, y: 0))
                path.addLine(to: CGPoint(x: width - semicircleRadius, y: 0))
                path.addArc(
                    center: CGPoint(x: width - semicircleRadius, y: semicircleRadius),
                    radius: semicircleRadius,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 90),
                    clockwise: false
                )
                path.addLine(to: CGPoint(x: cornerRadius, y: height))
                path.addArc(
                    center: CGPoint(x: cornerRadius, y: height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false
                )
                path.closeSubpath()
            }

            return path
        }
    }
}

// MARK: - GoalDetailTagsSection_Previews

struct GoalDetailTagsSection_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.listBackgroundColor
            GoalDetailTagsSection(viewModel: GoalDetailViewModel(goal: User.main.getGoals()
                    .sorted(by: { $0.timeRemaining > $1.timeRemaining })
                    .last!))
                .padding()
        }
        .ignoresSafeArea()
    }
}
