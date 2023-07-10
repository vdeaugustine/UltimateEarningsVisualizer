

import SwiftUI

// MARK: - BottomBannerModifier

struct BottomBannerModifier: ViewModifier {
    @Binding var isVisible: Bool
    var swipeToDismiss: Bool = true
    var mainText: String
    /// When set to true, the view in which the banner is popping over will be disabled until banner is dismissed
    var disableUnderlyingView: Bool = false
    /// When set to true, the view in which the banner is popping over will be blurred until banner is dismissed
    var blurUnderlyingView: Bool = false
    var blurRadius: CGFloat? = nil
    var buttonText: String? = nil
    var buttonAction: (() -> Void)?

    func body(content: Content) -> some View {
        ZStack {
            if isVisible {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                content
            }

            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(radius: 1)
                    HStack {
                        Image(systemName: "hourglass")
                            .font(.largeTitle)
                            .symbolRenderingMode(.multicolor)

                        VStack {
                            Text(mainText)
                                .font(.title3)
                        }
                        .padding(.leading)
                        Spacer()

                        Button(buttonText ?? "Dismiss") {
                            if let buttonAction {
                                buttonAction()
                            } else {
                                isVisible = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)
                }
                .frame(height: 100)
                .padding()
                .offset(y: isVisible ? 0 : 200)
                .animation(.easeInOut(duration: 0.3), value: isVisible)
                .gesture(isVisible && swipeToDismiss ? DragGesture(minimumDistance: 30, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.height > 0 {
                            isVisible = false
                        }
                    } : nil)
            }
        }
    }
}

// MARK: - BottomBannerWithNavigationModifier

struct BottomBannerWithNavigationModifier<Destination: View>: ViewModifier {
    @Binding var isVisible: Bool
    var swipeToDismiss: Bool = true
    var mainText: String
    /// When set to true, the view in which the banner is popping over will be disabled until banner is dismissed
    var disableUnderlyingView: Bool = false
    /// When set to true, the view in which the banner is popping over will be blurred until banner is dismissed
    var blurUnderlyingView: Bool = false
    var blurRadius: CGFloat? = nil
    var buttonText: String
    @ViewBuilder let destination: () -> Destination

    func body(content: Content) -> some View {
        ZStack {
            if isVisible {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                content
            }

            VStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(radius: 1)
                    HStack {
                        Image(systemName: "hourglass")
                            .font(.largeTitle)
                            .symbolRenderingMode(.multicolor)

                        VStack {
                            Text(mainText)
                                .font(.title3)
                        }
                        .padding(.leading)
                        Spacer()
                        NavigationLink(buttonText) {
                            destination()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)
                }
                .frame(height: 100)
                .padding()
                .offset(y: isVisible ? 0 : 200)
                .animation(.easeInOut(duration: 0.3), value: isVisible)
                .gesture(isVisible && swipeToDismiss ? DragGesture(minimumDistance: 30, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.height > 0 {
                            isVisible = false
                        }
                    } : nil)
            }
        }
    }
}

// Extension to make it easier to use the modifier
extension View {
    func bottomBanner(isVisible: Binding<Bool>,
                      mainText: String,
                      swipeToDismiss: Bool = true,
                      disableUnderlyingView: Bool = false,
                      blurUnderlyingView: Bool = false,
                      blurRadius: CGFloat? = nil,
                      buttonText: String? = nil,
                      buttonAction: (() -> Void)? = nil)
        -> some View {
        modifier(BottomBannerModifier(isVisible: isVisible,
                                      swipeToDismiss: swipeToDismiss,
                                      mainText: mainText,
                                      disableUnderlyingView: disableUnderlyingView,
                                      blurUnderlyingView: blurUnderlyingView,
                                      blurRadius: blurRadius,
                                      buttonText: buttonText,
                                      buttonAction: buttonAction))
    }

    func bottomBanner<Destination: View>(isVisible: Binding<Bool>,
                                         mainText: String,
                                         swipeToDismiss: Bool = true,
                                         disableUnderlyingView: Bool = false,
                                         blurUnderlyingView: Bool = false,
                                         blurRadius: CGFloat? = nil,
                                         buttonText: String,
                                         @ViewBuilder destination: @escaping () -> Destination)
        -> some View {
        modifier(
            BottomBannerWithNavigationModifier(isVisible: isVisible,
                                               swipeToDismiss: swipeToDismiss,
                                               mainText: mainText,
                                               disableUnderlyingView: disableUnderlyingView,
                                               blurUnderlyingView: blurUnderlyingView,
                                               blurRadius: blurRadius,
                                               buttonText: buttonText,
                                               destination: destination))
    }
}


