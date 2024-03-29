//
//  PayoffItemDetailHeaderView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/10/23.
//

import SwiftUI

// MARK: - CircleOverlayModifier

struct CircleOverlayModifier<V: View>: ViewModifier {
    var degrees: Double
    let widthHeight: Double
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
//        GeometryReader { geo in
        ZStack {
            content
            overlayView
                .position(x: points(width: widthHeight).x,
                          y: points(width: widthHeight).y)
        }
//        }
    }
}

extension View {
    func overlayOnCircle<V: View>(degrees: Double, widthHeight: CGFloat, @ViewBuilder overlayView: () -> V) -> some View {
        modifier(
            CircleOverlayModifier(degrees: degrees, widthHeight: widthHeight,
                                  overlayView: overlayView())
        )
    }
}

// MARK: - PayoffItemDetailHeaderView

struct PayoffItemDetailHeaderView: View {
    @ObservedObject var viewModel: PayoffItemDetailViewModel
    let shownImage: UIImage?
    let tappedImageAction: (() -> Void)?
    var tappedDateAction: (() -> Void)? = nil

    var dueDateLineString: String {
        if let dueDate = viewModel.payoffItem.dueDate {
            return dueDate.getFormattedDate(format: .abbreviatedMonth)
        } else {
            return "Set a due date"
        }
    }

    var image: Image {
        if let shownImage {
            return Image(uiImage: shownImage)
        } else if let image = viewModel.payoffItem.loadImageIfPresent() {
            return Image(uiImage: image)
        } else {
            return Image("dollar3d")
        }
    }

    var body: some View {
        VStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 150, height: 150)
                .overlayOnCircle(degrees: 37, widthHeight: 150) {
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

            VStack(spacing: 30) {
                VStack {
                    Text(viewModel.payoffItem.titleStr)
                        .font(.title)
                        .fontWeight(.bold)

                    if let info = viewModel.payoffItem.info {
                        Text(info)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                }
//                Text(PayoffItem.amountMoneyStr)
//                    .boldNumber()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - PayoffItemDetailHeaderView_Previews

struct PayoffItemDetailHeaderView_Previews: PreviewProvider {
    static let item = User.main.getGoals().first!
    static var previews: some View {
        PayoffItemDetailHeaderView(viewModel: PayoffItemDetailViewModel.init(payoffItem: item), shownImage: item.loadImageIfPresent()) {
        } tappedDateAction: {
        }
    }
}
