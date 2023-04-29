

import SwiftUI

// MARK: - BottomBannerModifier

struct BottomBannerModifier: ViewModifier {
    @Binding var isVisible: Bool
    var swipeToDismiss: Bool = true
    
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
                            Text("Shift complete!")
                                .font(.title3)
                        }
                        .padding(.leading)
                        Spacer()
                        
                        Button(buttonText ?? "Dismiss") {
                            if let buttonAction {
                                
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
                
            }
            
        }
        .gesture(isVisible && swipeToDismiss ? DragGesture(minimumDistance: 30, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.height > 0 {
                            isVisible = false
                        }
                    } : nil)
        
    }
}

// Extension to make it easier to use the modifier
extension View {
    func bottomBanner(isVisible: Binding<Bool>,
                      swipeToDismiss: Bool = true,
                      disableUnderlyingView: Bool = false,
                      blurUnderlyingView: Bool = false,
                      blurRadius: CGFloat? = nil,
                      buttonText: String? = nil,
                      buttonAction: (() -> Void)? = nil)
    -> some View {
        modifier(BottomBannerModifier(isVisible: isVisible,
                                      swipeToDismiss: swipeToDismiss,
                                      disableUnderlyingView: disableUnderlyingView,
                                      blurUnderlyingView: blurUnderlyingView,
                                      blurRadius: blurRadius,
                                      buttonText: buttonText,
                                      buttonAction: buttonAction))
    }
}

import SwiftUI

// MARK: - BottomBannerTodayLive

struct BottomBannerTodayLive: View {
    @State private var isBannerVisible = true
    
    var body: some View {
        VStack {
            Button("Toggle Banner") {
                isBannerVisible.toggle()
            }
        }
        .bottomBanner(isVisible: $isBannerVisible)
    }
}

// MARK: - BottomBannerTodayLive_Previews

struct BottomBannerTodayLive_Previews: PreviewProvider {
    static var previews: some View {
        BottomBannerTodayLive()
            .previewLayout(.sizeThatFits)
    }
}
