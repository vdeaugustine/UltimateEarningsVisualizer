//
//  GoalDetailHeaderView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/10/23.
//

import SwiftUI

// MARK: - CircleOverlayModifier

struct CircleOverlayModifier<V: View>: ViewModifier {
    var degrees: Double
    var overlayView: V

    func points(width: CGFloat) -> (x: CGFloat, y: CGFloat) {
        pointOnCircle(height: width, width: width, degrees: degrees)
    }

    func pointOnCircle(height: CGFloat, width: CGFloat, degrees: CGFloat) -> (x: CGFloat, y: CGFloat) {
        // Calculate the radius of the circle
        let radius = min(height, width) / 2

        // Calculate the x and y coordinates of the point on the circle at degrees
        let x = radius * cos(degrees * .pi / 180)
        let y = radius * sin(degrees * .pi / 180)

        // Return the x and y coordinates, adjusting for the center of the rectangle
        return (x + width / 2, y + height / 2)
    }

    func body(content: Content) -> some View {
        GeometryReader { geo in
            ZStack {
                content
                overlayView
                    .position(x: points(width: geo.size.width).x,
                              y: points(width: geo.size.width).y)
            }
        }
    }
}

extension View {
    func overlayOnCircle<V: View>(degrees: Double, @ViewBuilder overlayView: () -> V) -> some View {
        modifier(
            CircleOverlayModifier(degrees: degrees,
                                  overlayView: overlayView())
        )
    }
}

// MARK: - GoalDetailHeaderView

struct GoalDetailHeaderView: View {
    let goal: Goal

    let tappedImageAction: (() -> Void)?
    var tappedDateAction: (() -> Void)? = nil

    var dueDateLineString: String {
        if let dueDate = goal.dueDate {
            return dueDate.getFormattedDate(format: .abreviatedMonth)
        } else {
            return "Set a due date"
        }
    }

    var body: some View {
        VStack {
            Image("dollar3d")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
//                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .overlayOnCircle(degrees: 37) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.largeTitle)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .symbolRenderingMode(.multicolor)
                        .foregroundStyle(User.main.getSettings().getDefaultGradient())
                }
                .onTapGesture {
                    tappedImageAction?()
                }
                .frame(width: 150, height: 150)

            Text(goal.titleStr)
                .font(.title)
                .fontWeight(.bold)

            Text(dueDateLineString)
                .font(.caption)
                .foregroundColor(.gray)

            if let info = goal.info {
                Text(info)
                    .font(.body)
                    .padding(.top, 10)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - UserProfileView_Previews

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        GoalDetailHeaderView(goal: User.main.getGoals().first!) {
        } tappedDateAction: {
        }
    }
}
