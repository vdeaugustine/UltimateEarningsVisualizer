//
//  FloatingButtonView.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 9/4/23.
//

import FloatingButton
import SwiftUI
import Vin
//
//  File.swift
//
//
//  Created by Vincent DeAugustine on 10/11/23.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
public extension View {
    /// A SwiftUI view modifier to add popover presentation functionality to the SwiftUI `View`.
    ///
    /// Utilizing this extension allows a popover to be presented, customized with the specified arrow directions, and contain SwiftUI `View` content.
    ///
    /// Example Usage:
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var isPopoverPresented = false
    ///
    ///     var body: some View {
    ///         Button("Show Popover") {
    ///             isPopoverPresented.toggle()
    ///         }
    ///         .floatingPopover(isPresented: $isPopoverPresented,
    ///                          arrowDirection: .up) {
    ///             Text("Hello, Popover!")
    ///         }
    ///     }
    /// }
    /// ```
    ///
//    @ViewBuilder
//    func floatingPopover<Content: View>(isPresented: Binding<Bool>,
//                                        arrowDirection: UIPopoverArrowDirection,
//                                        @ViewBuilder content: @escaping () -> Content)
//        -> some View {
//        background {
//            FloatingPopOverController(isPresented: isPresented, arrowDirection: arrowDirection, content: content())
//        }
//    }
    
    @ViewBuilder
    func defaultPopover(isPresented: Binding<Bool>, text: String, direction: UIPopoverArrowDirection, color: Color? = nil, font: Font = .subheadline) -> some View {
        floatingPopover(isPresented: isPresented, arrowDirection: direction) {
            VStack(spacing: 12){
                Text(text)
                    .font(font)
                    .lineLimit(3)
                    .foregroundColor(color == .clear ? .primary : .white)
            }
            .padding(15)
            .background {
                Rectangle()
                    .fill((color ?? User.main.getSettings().themeColor).gradient)
                    .padding(-20)
            }
        }
    }
}

// MARK: - FloatingPopOverController

/// Popover Helper
///
/// `FloatingPopOverController` is a helper structure that wraps a SwiftUI view and presents it using UIKit's popover presentation mechanics.
///
/// It adheres to `UIViewControllerRepresentable` protocol to bridge between SwiftUI and UIKit, presenting SwiftUI views within UIKit's popover.
/// The presented content can be customized to update with SwiftUI state and interactions.
///
/// - Important: This component is fileprivate and designed to be used internally through `View` extensions.
///
@available(iOS 15.0, *)
struct FloatingPopOverController<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var arrowDirection: UIPopoverArrowDirection
    var content: Content
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let hostingController = uiViewController.presentedViewController as? CustomHostingView<Content>{
            /// - Close View, if it's toggled Back
            if !isPresented {
                /// - Closing Popover
                uiViewController.dismiss(animated: true)
            } else {
                hostingController.rootView = content
                /// - Updating View Size when it's Update
                /// - Or You can define your own size in SwiftUI View
                hostingController.preferredContentSize = hostingController.view.intrinsicContentSize
                /// - If you don't want animation
                // UIView.animate(withDuration: 0) {
                //    hostingController.preferredContentSize = hostingController.view.intrinsicContentSize
                // }
            }
        } else {
            if isPresented{
                /// - Presenting Popover
                let controller = CustomHostingView(rootView: content)
                controller.view.backgroundColor = .clear
                controller.modalPresentationStyle = .popover
                controller.popoverPresentationController?.permittedArrowDirections = arrowDirection
                /// - Connecting Delegate
                controller.presentationController?.delegate = context.coordinator
                /// - We Need to Attach the Source View So that it will show Arrow At Correct Position
                controller.popoverPresentationController?.sourceView = uiViewController.view
                /// - Simply Presenting PopOver Controller
                uiViewController.present(controller, animated: true)
            }
        }
    }

    /// Forcing it to show Popover using PresentationDelegate
    ///
    /// `Coordinator` is a delegate adhering to `UIPopoverPresentationControllerDelegate`, ensuring to manage the presentation style and dismissal updates.
    ///
    /// It enforces the popover to always display as a popover (not adapting for compact size classes), and monitors the dismissal of the popover to update the SwiftUI state binding (`isPresented`).
    ///
    class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
        var parent: FloatingPopOverController
        init(parent: FloatingPopOverController) {
            self.parent = parent
        }

        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }

        /// - Observing The status of the Popover
        /// - When it's dismissed updating the isPresented State
        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
        }
    }
}

// MARK: - CustomHostingView

/// Custom Hosting Controller for Wrapping to it's SwiftUI View Size
///
/// `CustomHostingView` is a specialized `UIHostingController` designed to adjust the preferred content size based on intrinsic content size, ensuring SwiftUI views size accurately within UIKit's hosting environment.
///
/// - Note: This class will adhere to the sizing behaviors of SwiftUI views and utilize the `intrinsicContentSize` to determine the `preferredContentSize` utilized by UIKit's popover presentation mechanics.
///
@available(iOS 15.0, *)

fileprivate class CustomHostingView<Content: View>: UIHostingController<Content>{
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = view.intrinsicContentSize
    }
}


// MARK: - FloatingPlusButton

struct FloatingPlusButton: View {
    @ObservedObject private var settings = User.main.getSettings()
    @Binding var isShowing: Bool
    @State private var showGoalPopover = !(User.main.statusTracker?.hasSeenFirstGoalPopover ?? false)

    let expense = MainMenuRow(title: "Expense", iconString: IconManager.expenseString) {
        NavManager.shared.appendCorrectPath(newValue: .createExpense)
    }
    let goal = MainMenuRow(title: "Goal", iconString: IconManager.goalsString) {
        NavManager.shared.appendCorrectPath(newValue: .createGoal)
    }
    let savedItem = MainMenuRow(title: "Saved") {
        NavManager.shared.appendCorrectPath(newValue: .createSaved)
    } icon: {
        IconManager.savedIcon.stroke(lineWidth: 1.5).aspectRatio(contentMode: .fit)
    }

    let shift = MainMenuRow(title: "Shift", iconString: IconManager.shiftsString) {
        NavManager.shared.appendCorrectPath(newValue: .createShift)
    }

    var body: some View {
        VStack {
            FloatingButton(mainButtonView: mainView, buttons: [expense, goal, savedItem, shift], isOpen: $isShowing)
                .straight()
                .direction(.top)
                .initialOpacity(0)
                .alignment(.right)
                .onChange(of: isShowing) { _ in
                    Taptic.medium()
                }
        }
    }

    var mainView: some View {
        VStack {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .background(Circle().fill(.white))
                .foregroundStyle(settings.getDefaultGradient())
                .rotationEffect(.degrees(isShowing ? 315 : 0))
                .animation(.default, value: isShowing)
        }
    }
}

// MARK: - MainMenuRow

struct MainMenuRow: View {
    let title: String

    let icon: () -> AnyView
    let height: CGFloat

    let action: () -> Void

    init(title: String, height: CGFloat = 40, action: @escaping () -> Void, @ViewBuilder icon: @escaping () -> any View) {
        self.title = title
        self.icon = { icon().anyView }
        self.height = height
        self.action = action
    }

    init(title: String, height: CGFloat = 40, iconString: String, action: @escaping () -> Void) {
        self.title = title
        self.icon = {
            Image(systemName: iconString)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .font(.subheadline)
                .anyView
        }
        self.height = height
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
    //            Spacer()
                icon()
                    .frame(maxWidth: height - 15)
                Text(title)
            }
            .font(.subheadline)
            .foregroundStyle(Color(uiColor: .secondaryLabel))
            .padding(7)
            .frame(width: 115, height: height, alignment: .leading)
            .background { Color.listBackgroundColor }
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
            .shadow(radius: 0.5)
        }
    }
}

// MARK: - FloatingButtonView_Previews

struct FloatingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingPlusButton(isShowing: .constant(true))
        MainMenuRow(title: "Expenses", iconString: IconManager.expenseString) {}
    }
}
