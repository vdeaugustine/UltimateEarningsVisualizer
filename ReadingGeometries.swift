////
////  ReadingGeometries.swift
////  UltimateMoneyVisualizer
////
////  Created by Vincent DeAugustine on 10/14/23.
////
//
//import SwiftUI
//
//// MARK: - ReadingGeometries
//
//struct ReadingGeometries: View {
//    @State private var firstOffset: CGPoint = .zero
//    @State private var secondOffset: CGPoint = .zero
//    @State private var offset: CGPoint = .zero
//
//    var body: some View {
//        UIScrollViewWrapper(offset: $offset)
//    }
//
////    var body: some View {
////        VStack {
////            ScrollView {
////                ForEach(0..<100) { index in
////                    Text("First \(index)")
////                }
////            }
////            .scrollOffset(key: FirstOffsetKey.self)
////            .onPreferenceChange(FirstOffsetKey.self) { value in
////                self.firstOffset = value
////                print("\(value)")
////            }
////
////            ScrollView {
////                ForEach(0..<100) { index in
////                    Text("Second \(index)")
////                }
////            }
////            .scrollOffset(key: SecondOffsetKey.self)
////            .onPreferenceChange(SecondOffsetKey.self) { value in
////                self.secondOffset = value
////            }
////        }
////        .onChangeProper(of: firstOffset) {
////            print(firstOffset)
////        }
////        .onChangeProper(of: secondOffset) {
////            print("Second:", secondOffset)
////        }
////    }
//}
//
//// MARK: - ScrollOffsetModifier
//
//struct ScrollOffsetModifier<Key: PreferenceKey>: ViewModifier where Key.Value == CGPoint {
//    func body(content: Content) -> some View {
//        content
//            .overlay(
//                GeometryReader { geometry in
//                    Color.clear
//                        .preference(key: Key.self, value: geometry.frame(in: .global).origin)
//                }
//            )
//    }
//}
//
//extension View {
//    func scrollOffset<Key: PreferenceKey>(key: Key.Type) -> some View where Key.Value == CGPoint {
//        modifier(ScrollOffsetModifier<Key>())
//    }
//}
//
//// MARK: - FirstOffsetKey
//
//struct FirstOffsetKey: PreferenceKey {
//    static var defaultValue: CGPoint = .zero
//    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
//        value = nextValue()
//    }
//}
//
//// MARK: - SecondOffsetKey
//
//struct SecondOffsetKey: PreferenceKey {
//    static var defaultValue: CGPoint = .zero
//    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
//        value = nextValue()
//    }
//}
//
//// MARK: - UIScrollViewWrapper
//
//struct UIScrollViewWrapper: UIViewControllerRepresentable {
//    class Coordinator: NSObject, UIScrollViewDelegate {
//        var parent: UIScrollViewWrapper
//
//        init(parent: UIScrollViewWrapper) {
//            self.parent = parent
//        }
//
//        func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            parent.offset = scrollView.contentOffset
//        }
//    }
//
//    @Binding var offset: CGPoint
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = UIViewController()
//        let scrollView = UIScrollView()
//        scrollView.delegate = context.coordinator
//        viewController.view = scrollView
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        if let scrollView = uiViewController.view as? UIScrollView {
//            scrollView.contentSize = contentSize
//        }
//    }
//}
//
//#Preview {
//    ReadingGeometries()
//}
