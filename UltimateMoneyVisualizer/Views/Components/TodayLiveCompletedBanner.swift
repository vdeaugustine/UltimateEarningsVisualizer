

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
    let onDismiss: (() -> Void)?

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
                .gesture(dragDismissGesture)
            }
        }
    }

    private var dragDismissGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { _ in
                if $isVisible.wrappedValue {
                    $isVisible.wrappedValue = false
                    onDismiss?()
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
    let onDismiss: (() -> Void)?

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
                .gesture(dragDismissGesture)
            }
        }
    }

    private var dragDismissGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { _ in
                if $isVisible.wrappedValue {
                    $isVisible.wrappedValue = false
                    onDismiss?()
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
                      buttonAction: (() -> Void)? = nil,
                      onDismiss: (() -> Void)?)
        -> some View {
        modifier(BottomBannerModifier(isVisible: isVisible,
                                      swipeToDismiss: swipeToDismiss,
                                      mainText: mainText,
                                      disableUnderlyingView: disableUnderlyingView,
                                      blurUnderlyingView: blurUnderlyingView,
                                      blurRadius: blurRadius,
                                      buttonText: buttonText,
                                      buttonAction: buttonAction,
                                      onDismiss: onDismiss))
    }

    func bottomBanner<Destination: View>(isVisible: Binding<Bool>,
                                         mainText: String,
                                         swipeToDismiss: Bool = true,
                                         disableUnderlyingView: Bool = false,
                                         blurUnderlyingView: Bool = false,
                                         blurRadius: CGFloat? = nil,
                                         buttonText: String,
                                         @ViewBuilder destination: @escaping () -> Destination,
                                         onDismiss: (() -> Void)?)
        -> some View {
        modifier(
            BottomBannerWithNavigationModifier(isVisible: isVisible,
                                               swipeToDismiss: swipeToDismiss,
                                               mainText: mainText,
                                               disableUnderlyingView: disableUnderlyingView,
                                               blurUnderlyingView: blurUnderlyingView,
                                               blurRadius: blurRadius,
                                               buttonText: buttonText,
                                               destination: destination,
                                               onDismiss: onDismiss))
    }
}
