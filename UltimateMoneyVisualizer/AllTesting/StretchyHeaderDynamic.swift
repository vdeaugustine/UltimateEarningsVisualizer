//
//  StretchyHeaderDynamic.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 7/11/23.
//

import SwiftUI

// MARK: - StretchyHeaderDynamic

struct StretchyHeaderDynamic: View {
    var author: String
    var date: String
    var title: String
    var bodyText: String
    var headerImageName: String
    var authorImageName: String

    private let imageHeight: CGFloat = 300
    private let collapsedImageHeight: CGFloat = 90
    
//    private let adjustedHeightForBar: CGFloat = 30

    @ObservedObject private var articleContent: ViewFrame = ViewFrame()
    @State private var titleRect: CGRect = .zero
    @State private var headerImageRect: CGRect = .zero

    func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }

    func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let sizeOffScreen = imageHeight - collapsedImageHeight

        if offset < -sizeOffScreen {
            let imageOffset = abs(min(-sizeOffScreen, offset))

            return imageOffset - sizeOffScreen
        }

        if offset > 0 {
            return -offset
        }

        return 0
    }

    func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }

        return imageHeight
    }

    func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).maxY
        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height

        return blur * 6
    }

    /// This offset is used for the actual text part of the de facto Nav bar
    private func getHeaderTitleOffset() -> CGFloat {
        let currentYPos = titleRect.midY

        if currentYPos < headerImageRect.maxY {
            let minYValue: CGFloat = 50.0
            let maxYValue: CGFloat = collapsedImageHeight
            let currentYValue = currentYPos
            let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - minYValue))
            let finalOffset: CGFloat = -35

            return 25 - (percentage * finalOffset)
        }

        return .infinity
    }

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(authorImageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                            .shadow(radius: 4)

                        VStack(alignment: .leading) {
                            Text("Article Written By")
                                .font(.avenirNext(size: 12))
                                .foregroundColor(.gray)
                            Text(author)
                                .font(.avenirNext(size: 17))
                        }
                        Spacer()
                    }

                    Text(date)
                        .font(.avenirNextRegular(size: 12))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)

                    Text(title)
                        .font(.avenirNext(size: 28))
                        .background(GeometryGetter(key: RectanglePreferenceKey.self, value: self.$titleRect))

                    Text(bodyText)
                        .lineLimit(nil)
                        .font(.avenirNextRegular(size: 17))
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.top, 16.0)
            }
            .offset(y: imageHeight + 16)
            .background(GeometryGetter(key: RectanglePreferenceKey.self, value: $articleContent.frame))

            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    Image(headerImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                        .blur(radius: self.getBlurRadiusForImage(geometry))
                        .clipped()
                        .background(GeometryGetter(key: RectanglePreferenceKey.self, value: self.$headerImageRect))

                    Text(title)
                        .font(.avenirNext(size: 17))
                        .foregroundColor(.white)
                        .offset(x: 0, y: self.getHeaderTitleOffset())
                }
                .clipped()
                .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
            }
            .frame(height: imageHeight )

            .offset(x: 0, y: -(articleContent.startingRect?.maxY ?? UIScreen.main.bounds.height))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// MARK: - StretchyHeaderDynamic_Previews

struct StretchyHeaderDynamic_Previews: PreviewProvider {
    static let placeholderText = """
Lorem ipsum dolor sit amet consectetur adipiscing elit donec, gravida commodo hac non mattis augue duis vitae inceptos, laoreet taciti at vehicula cum arcu dictum. Cras netus vivamus sociis pulvinar est erat, quisque imperdiet velit a justo maecenas, pretium gravida ut himenaeos nam. Tellus quis libero sociis class nec hendrerit, id proin facilisis praesent bibendum vehicula tristique, fringilla augue vitae primis turpis.

Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.

Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.

Sagittis vivamus sem morbi nam mattis phasellus vehicula facilisis suscipit posuere metus, iaculis vestibulum viverra nisl ullamcorper lectus curabitur himenaeos dictumst malesuada tempor, cras maecenas enim est eu turpis hac sociosqu tellus magnis. Sociosqu varius feugiat volutpat justo fames magna malesuada, viverra neque nibh parturient eu nascetur, cursus sollicitudin placerat lobortis nunc imperdiet. Leo lectus euismod morbi placerat pretium aliquet ultricies metus, augue turpis vulputa
te dictumst mattis egestas laoreet, cubilia habitant magnis lacinia vivamus etiam aenean.
"""
    static var previews: some View {
        Text(placeholderText)
            .modifier(StretchyHeaderModifier(headerImageName: "dollar3d"))
//        StretchyHeaderDynamic(author: "Teddy",
//                              date: "02/05/1996",
//                              title: "Something",
//                              bodyText: placeholderText,
//                              headerImageName: "",
//                              authorImageName: "dollar3d")
    }
}


// MARK: - StretchyHeaderModifier

struct StretchyHeaderModifier: ViewModifier {
    let headerImageName: String
    var titleWhenScrolled: String? = nil

    private let imageHeight: CGFloat = 300
    private let collapsedImageHeight: CGFloat = 90

    @ObservedObject private var articleContent: ViewFrame = ViewFrame()
    @State private var headerImageRect: CGRect = .zero

    func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }

    func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let sizeOffScreen = imageHeight - collapsedImageHeight

        if offset < -sizeOffScreen {
            let imageOffset = abs(min(-sizeOffScreen, offset))

            return imageOffset - sizeOffScreen
        }

        if offset > 0 {
            return -offset
        }

        return 0
    }

    func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }

        return imageHeight
    }

    func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).maxY
        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height

        return blur * 6
    }

    func body(content: Content) -> some View {
        ScrollView {
            VStack {
                content
                    .offset(y: imageHeight + 16)
                    .background(GeometryGetter(key: RectanglePreferenceKey.self, value: $articleContent.frame))

                GeometryReader { geometry in
                    ZStack(alignment: .bottom) {
                        Image(headerImageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
                            .blur(radius: self.getBlurRadiusForImage(geometry))
                            .clipped()
                            .background(GeometryGetter(key: RectanglePreferenceKey.self, value: self.$headerImageRect))
                    }
                    .clipped()
                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
                }
                .frame(height: imageHeight)
                .offset(x: 0, y: -(articleContent.startingRect?.maxY ?? UIScreen.main.bounds.height))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
